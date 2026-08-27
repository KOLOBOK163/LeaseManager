package com.LeaseManager.Controller;

import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Service.Penalty.PenaltyService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * Контроллер для управления пенями за просрочку
 */
@RestController
@RequestMapping("/api/penalties")
public class PenaltyController {

    private final PenaltyService penaltyService;

    public PenaltyController(PenaltyService penaltyService) {
        this.penaltyService = penaltyService;
    }

    /**
     * Рассчитать пеню для графика платежей
     */
    @GetMapping("/calculate/schedule/{scheduleId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> calculatePenalty(@PathVariable Long scheduleId) {
        BigDecimal penalty = penaltyService.calculatePenaltyForSchedule(scheduleId);
        return ResponseEntity.ok(penalty);
    }

    /**
     * Получить общую сумму пени по договору
     */
    @GetMapping("/total/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> getTotalPenalty(@PathVariable Long contractId) {
        BigDecimal totalPenalty = penaltyService.getTotalPenaltyForContract(contractId);
        return ResponseEntity.ok(totalPenalty);
    }

    /**
     * Создать платёж для пени
     */
    @PostMapping("/create/schedule/{scheduleId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<Payment> createPenaltyPayment(@PathVariable Long scheduleId) {
        Payment payment = penaltyService.createPenaltyPayment(scheduleId);
        return ResponseEntity.ok(payment);
    }

    /**
     * Получить все платежи-пени по договору
     */
    @GetMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<Payment>> getPenaltyPayments(@PathVariable Long contractId) {
        List<Payment> payments = penaltyService.getPenaltyPaymentsByContract(contractId);
        return ResponseEntity.ok(payments);
    }

    /**
     * Получить сумму неоплаченных пени по договору
     */
    @GetMapping("/unpaid/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> getUnpaidPenalty(@PathVariable Long contractId) {
        BigDecimal unpaidPenalty = penaltyService.getUnpaidPenaltyForContract(contractId);
        return ResponseEntity.ok(unpaidPenalty);
    }

    /**
     * Получить текущую ставку пени
     */
    @GetMapping("/rate")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> getPenaltyRate() {
        BigDecimal rate = penaltyService.getDailyPenaltyRate();
        return ResponseEntity.ok(rate);
    }

    /**
     * Установить ставку пени (только для администратора)
     */
    @PutMapping("/rate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> setPenaltyRate(@RequestParam BigDecimal rate) {
        penaltyService.setDailyPenaltyRate(rate);
        return ResponseEntity.ok().build();
    }
}
