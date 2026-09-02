package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Contract.*;
import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Service.Audit.AuditService;
import com.LeaseManager.Service.Contract.ContractService;
import com.LeaseManager.Util.AuditUtil;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contracts")
public class ContractController {

    private final ContractService contractService;
    private final AuditService auditService;

    public ContractController(ContractService contractService, AuditService auditService) {
        this.contractService = contractService;
        this.auditService = auditService;
    }

    @GetMapping
    public ResponseEntity<List<ContractResponse>> getAllContracts(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String search) {
        return ResponseEntity.ok(contractService.getAllContracts(status, search));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ContractResponse> getContractById(@PathVariable Long id) {
        return ResponseEntity.ok(contractService.getContractById(id));

    }

    @PostMapping
    public ResponseEntity<ContractResponse> createContract(@Valid @RequestBody CreateContractRequest request) {
        ContractResponse created = contractService.createContract(request);
        auditService.log(
            AuditUtil.getCurrentUserId(),
            AuditLog.AuditAction.CREATE,
            "Contract",
            created.getId(),
            "Создан договор: " + created.getContractNumber(),
            AuditUtil.getClientIp()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ContractResponse> updateContract(@PathVariable Long id, @Valid @RequestBody UpdateContractRequest request) {
        ContractResponse updated = contractService.updateContract(id, request);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.UPDATE,
                "Contract",
                id,
                "Обновлен договор: " + updated.getContractNumber(),
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(updated);
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<ContractResponse> changeStatus(@PathVariable Long id, @Valid @RequestBody ChangeContractStatusRequest request) {
        ContractResponse contract = contractService.getContractById(id);
        String oldStatus = contract.getStatus().toString();
        ContractResponse updated = contractService.changeStatus(id, request);

        auditService.logWithChanges(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.STATUS_CHANGE,
                "Contract",
                id,
                "Статус договора " + updated.getContractNumber() + " изменен: " + oldStatus + " → " + updated.getStatus(),
                "{\"status\": \"" + oldStatus + "\"}",
                "{\"status\": \"" + updated.getStatus() + "\"}",
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteContract(@PathVariable Long id) {
        ContractResponse contract = contractService.getContractById(id);
        contractService.delete(id);

        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.DELETE,
                "Contract",
                id,
                "Удален договор: " + contract.getContractNumber(),
                AuditUtil.getClientIp()
        );
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/payment-schedule/generate")
    public ResponseEntity<List<PaymentSchedule>> generatePaymentSchedule(@PathVariable Long id, @RequestBody(required = false) GeneratePaymentScheduleRequest request) {
        if (request == null) {
            request = new GeneratePaymentScheduleRequest();
        }
        request.setContractId(id);
        List<PaymentSchedule> schedules = contractService.generatePaymentSchedule(request);

        ContractResponse contract = contractService.getContractById(id);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.CREATE,
                "PaymentSchedule",
                id,
                "Сгенерирован график платежей для договора " + contract.getContractNumber() + " (" + schedules.size() + " периодов)",
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(schedules);
    }

    @GetMapping("/{id}/statistics")
    public ResponseEntity<ContractStatisticsDto> getContractStatistics(@PathVariable Long id) {
        ContractStatisticsDto statistics = contractService.getContractStatistics(id);
        return ResponseEntity.ok(statistics);
    }
}
