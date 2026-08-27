package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Contract.ChangeContractStatusRequest;
import com.LeaseManager.Dto.Contract.ContractStatisticsDto;
import com.LeaseManager.Dto.Contract.CreateContractRequest;
import com.LeaseManager.Dto.Contract.GeneratePaymentScheduleRequest;
import com.LeaseManager.Dto.Contract.UpdateContractRequest;
import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Service.Audit.AuditService;
import com.LeaseManager.Service.ContractService;
import com.LeaseManager.Util.AuditUtil;
import jakarta.persistence.EntityNotFoundException;
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
    public ResponseEntity<List<Contract>> getAllContracts(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String search) {
        return ResponseEntity.ok(contractService.getAllContracts(status, search));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Contract> getContractById(@PathVariable Long id) {
        try {
            Contract contract = contractService.getContractById(id);
            return ResponseEntity.ok(contract);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<Contract> createContract(@Valid @RequestBody CreateContractRequest request) {
        Contract created = contractService.createContract(request);

        // Логируем создание
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
    public ResponseEntity<Contract> updateContract(
            @PathVariable Long id,
            @Valid @RequestBody UpdateContractRequest request) {
        try {
            Contract updated = contractService.updateContract(id, request);

            // Логируем обновление
            auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.UPDATE,
                "Contract",
                id,
                "Обновлен договор: " + updated.getContractNumber(),
                AuditUtil.getClientIp()
            );

            return ResponseEntity.ok(updated);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Contract> changeStatus(
            @PathVariable Long id,
            @Valid @RequestBody ChangeContractStatusRequest request) {
        try {
            Contract contract = contractService.getContractById(id);
            String oldStatus = contract.getStatus().toString();

            Contract updated = contractService.changeStatus(id, request);

            // Логируем изменение статуса
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
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteContract(@PathVariable Long id) {
        try {
            Contract contract = contractService.getContractById(id);

            contractService.delete(id);

            // Логируем удаление
            auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.DELETE,
                "Contract",
                id,
                "Удален договор: " + contract.getContractNumber(),
                AuditUtil.getClientIp()
            );

            return ResponseEntity.noContent().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Генерация графика платежей по договору
     */
    @PostMapping("/{id}/payment-schedule/generate")
    public ResponseEntity<List<PaymentSchedule>> generatePaymentSchedule(
            @PathVariable Long id,
            @RequestBody(required = false) GeneratePaymentScheduleRequest request) {
        try {
            if (request == null) {
                request = new GeneratePaymentScheduleRequest();
            }
            request.setContractId(id);
            List<PaymentSchedule> schedules = contractService.generatePaymentSchedule(request);

            Contract contract = contractService.getContractById(id);

            // Логируем генерацию графика
            auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.CREATE,
                "PaymentSchedule",
                id,
                "Сгенерирован график платежей для договора " + contract.getContractNumber() + " (" + schedules.size() + " периодов)",
                AuditUtil.getClientIp()
            );

            return ResponseEntity.ok(schedules);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Получение статистики по договору
     */
    @GetMapping("/{id}/statistics")
    public ResponseEntity<ContractStatisticsDto> getContractStatistics(@PathVariable Long id) {
        try {
            ContractStatisticsDto statistics = contractService.getContractStatistics(id);
            return ResponseEntity.ok(statistics);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
