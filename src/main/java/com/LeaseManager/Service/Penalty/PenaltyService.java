package com.LeaseManager.Service.Penalty;

import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Repository.PaymentRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Сервис для расчёта пени за просрочку платежей
 */
@Service
public class PenaltyService {

    private final PaymentScheduleRepository paymentScheduleRepository;
    private final PaymentRepository paymentRepository;

    @Value("${penalty.daily-rate:0.1}")
    private BigDecimal dailyPenaltyRate; // 0.1% в день по умолчанию

    public PenaltyService(PaymentScheduleRepository paymentScheduleRepository,
                         PaymentRepository paymentRepository) {
        this.paymentScheduleRepository = paymentScheduleRepository;
        this.paymentRepository = paymentRepository;
    }

    /**
     * Рассчитать пеню за просрочку
     *
     * Формула: Пеня = Сумма платежа × Количество дней просрочки × Ставка пени
     * Ставка пени: 0.1% в день (по умолчанию)
     */
    public BigDecimal calculatePenalty(PaymentSchedule schedule) {
        if (schedule.getStatus() != PaymentScheduleStatus.OVERDUE) {
            return BigDecimal.ZERO;
        }

        LocalDate dueDate = schedule.getPaymentDate();
        LocalDate today = LocalDate.now();

        if (!today.isAfter(dueDate)) {
            return BigDecimal.ZERO;
        }

        // Количество дней просрочки
        long daysOverdue = ChronoUnit.DAYS.between(dueDate, today);

        // Сумма платежа
        BigDecimal amount = schedule.getTotalAmount();

        // Пеня = Сумма × Дни × Ставка
        BigDecimal penalty = amount
                .multiply(BigDecimal.valueOf(daysOverdue))
                .multiply(dailyPenaltyRate.divide(BigDecimal.valueOf(100), 10, BigDecimal.ROUND_HALF_UP));

        return penalty.setScale(2, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * Рассчитать пеню для конкретного графика платежей
     */
    @Transactional(readOnly = true)
    public BigDecimal calculatePenaltyForSchedule(Long scheduleId) {
        PaymentSchedule schedule = paymentScheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("График платежа не найден"));
        return calculatePenalty(schedule);
    }

    /**
     * Получить общую сумму пени по договору
     */
    @Transactional(readOnly = true)
    public BigDecimal getTotalPenaltyForContract(Long contractId) {
        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contractId);

        return schedules.stream()
                .filter(s -> s.getStatus() == PaymentScheduleStatus.OVERDUE)
                .map(this::calculatePenalty)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Создать платёж для пени
     */
    @Transactional
    public Payment createPenaltyPayment(Long scheduleId) {
        PaymentSchedule schedule = paymentScheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("График платежа не найден"));

        BigDecimal penaltyAmount = calculatePenalty(schedule);

        if (penaltyAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalStateException("Нет просрочки для начисления пени");
        }

        // Создаём платёж типа PENALTY
        Payment penaltyPayment = Payment.builder()
                .schedule(schedule)
                .contract(schedule.getContract())
                .amount(penaltyAmount)
                .dueDate(LocalDateTime.now())
                .paymentType(Payment.PaymentType.PENALTY)
                .status(Payment.PaymentStatus.PENDING)
                .comment("Пеня за просрочку платежа #" + schedule.getPeriodNumber() +
                        " (" + ChronoUnit.DAYS.between(schedule.getPaymentDate(), LocalDate.now()) + " дн.)")
                .build();

        return paymentRepository.save(penaltyPayment);
    }

    /**
     * Автоматическое начисление пени для просроченных платежей
     * Запускается каждый день в 23:00
     */
    @Scheduled(cron = "0 0 23 * * ?")
    @Transactional
    public void autoCalculatePenalties() {
        List<PaymentSchedule> overdueSchedules = paymentScheduleRepository
                .findAllByStatus(PaymentScheduleStatus.OVERDUE);

        int penaltiesCreated = 0;

        for (PaymentSchedule schedule : overdueSchedules) {
            // Проверяем, не создана ли уже пеня за сегодня
            boolean penaltyExists = schedule.getPayments().stream()
                    .anyMatch(p -> p.getPaymentType() == Payment.PaymentType.PENALTY &&
                                 p.getDueDate().toLocalDate().equals(LocalDate.now()));

            if (!penaltyExists) {
                try {
                    createPenaltyPayment(schedule.getId());
                    penaltiesCreated++;
                } catch (Exception e) {
                    // Логируем ошибку, но продолжаем обработку
                    System.err.println("Ошибка создания пени для графика " + schedule.getId() + ": " + e.getMessage());
                }
            }
        }

        System.out.println("Автоматически начислено пени: " + penaltiesCreated);
    }

    /**
     * Получить все платежи-пени по договору
     */
    @Transactional(readOnly = true)
    public List<Payment> getPenaltyPaymentsByContract(Long contractId) {
        return paymentRepository.findByContractId(contractId).stream()
                .filter(p -> p.getPaymentType() == Payment.PaymentType.PENALTY)
                .toList();
    }

    /**
     * Получить сумму неоплаченных пени по договору
     */
    @Transactional(readOnly = true)
    public BigDecimal getUnpaidPenaltyForContract(Long contractId) {
        return paymentRepository.findByContractId(contractId).stream()
                .filter(p -> p.getPaymentType() == Payment.PaymentType.PENALTY)
                .filter(p -> p.getStatus() == Payment.PaymentStatus.PENDING)
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Установить ставку пени
     */
    public void setDailyPenaltyRate(BigDecimal rate) {
        if (rate.compareTo(BigDecimal.ZERO) < 0 || rate.compareTo(BigDecimal.valueOf(1)) > 0) {
            throw new IllegalArgumentException("Ставка пени должна быть от 0 до 1%");
        }
        this.dailyPenaltyRate = rate;
    }

    /**
     * Получить текущую ставку пени
     */
    public BigDecimal getDailyPenaltyRate() {
        return dailyPenaltyRate;
    }
}
