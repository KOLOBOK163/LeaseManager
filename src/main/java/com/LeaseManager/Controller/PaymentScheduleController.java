package com.LeaseManager.Controller;

import com.LeaseManager.Dto.PaymentSchedule.CreatePaymentScheduleRequest;
import com.LeaseManager.Dto.PaymentSchedule.MarkAsPaidRequest;
import com.LeaseManager.Dto.PaymentSchedule.PaymentScheduleResponse;
import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Service.Audit.AuditService;
import com.LeaseManager.Service.PaymentSchedule.PaymentScheduleService;
import com.LeaseManager.Util.AuditUtil;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payment-schedules")
public class PaymentScheduleController {

    private final PaymentScheduleService paymentScheduleService;
    private final AuditService auditService;

    public PaymentScheduleController(PaymentScheduleService paymentScheduleService, AuditService auditService) {
        this.paymentScheduleService = paymentScheduleService;
        this.auditService = auditService;
    }

    @PostMapping
    public ResponseEntity<PaymentScheduleResponse> createSchedule(
            @Valid @RequestBody CreatePaymentScheduleRequest request) {
        PaymentScheduleResponse response = paymentScheduleService.createSchedule(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/contract/{contractId}")
    public ResponseEntity<List<PaymentScheduleResponse>> getSchedulesByContractId(@PathVariable Long contractId) {
        return ResponseEntity.ok(paymentScheduleService.getSchedulesByContractId(contractId));
    }

    @GetMapping("/overdue")
    public ResponseEntity<List<PaymentScheduleResponse>> getOverdueSchedules() {
        return ResponseEntity.ok(paymentScheduleService.getOverdueSchedules());
    }

    @PostMapping("/{id}/pay")
    public ResponseEntity<PaymentScheduleResponse> markAsPaid(@PathVariable Long id, @Valid @RequestBody(required = false) MarkAsPaidRequest request) {
        PaymentScheduleResponse response = paymentScheduleService.markAsPaid(id, request != null ? request : new MarkAsPaidRequest());
        auditService.logWithChanges(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.STATUS_CHANGE,
                "PaymentSchedule",
                id,
                "Платеж отмечен как оплаченный (Договор ID: " + response.getContractId() + ", Период: " + response.getPeriodNumber() + ", Сумма: " + response.getTotalAmount() + ")",
                "{\"status\": \"PENDING\"}",
                "{\"status\": \"PAID\"}",
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<PaymentScheduleResponse> cancelSchedule(@PathVariable Long id) {
        PaymentScheduleResponse response = paymentScheduleService.cancelSchedule(id);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.STATUS_CHANGE,
                "PaymentSchedule",
                id,
                "Платеж отменен (Договор ID: " + response.getContractId() + ", Период: " + response.getPeriodNumber() + ")",
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(response);
    }
}
