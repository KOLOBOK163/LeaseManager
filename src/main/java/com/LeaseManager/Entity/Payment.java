package com.LeaseManager.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Платеж по графику лизинговых платежей
 */
@Entity
@Table(name = "payments")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference("schedule-payments")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_id", nullable = false, foreignKey = @ForeignKey(name = "fk_payment_schedule"))
    private PaymentSchedule schedule;

    @JsonBackReference("contract-payments")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contract_id", nullable = false, foreignKey = @ForeignKey(name = "fk_payment_contract"))
    private Contract contract;

    @Column(name = "amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "due_date", nullable = false)
    private LocalDateTime dueDate;

    @Column(name = "paid_date")
    private LocalDateTime paidDate;

    @Column(name = "payment_type", length = 20)
    @Enumerated(EnumType.STRING)
    private PaymentType paymentType;

    @Column(name = "status", length = 20)
    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PaymentStatus status = PaymentStatus.PENDING;

    @Column(name = "comment", length = 500)
    private String comment;

    @Column(name = "payment_method", length = 20)
    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;

    /**
     * Способы оплаты
     */
    public enum PaymentMethod {
        BANK_TRANSFER,  // Безналичный расчёт
        CASH,           // Наличные
        CARD            // Банковская карта
    }

    /**
     * Типы платежей
     */
    public enum PaymentType {
        PRINCIPAL,      // Основной долг
        INTEREST,       // Проценты
        PENALTY,        // Штраф/пеня
        ADDITIONAL      // Дополнительные услуги
    }

    /**
     * Статусы платежа
     */
    public enum PaymentStatus {
        PENDING,    // Ожидает оплаты
        PAID,       // Оплачен
        CANCELLED,  // Отменен
        PARTIAL     // Частично оплачен
    }

    /**
     * Проверка оплаты
     */
    public boolean isPaid() {
        return status == PaymentStatus.PAID;
    }

    /**
     * Установка даты оплаты и статуса
     */
    public void markAsPaid() {
        this.paidDate = LocalDateTime.now();
        this.status = PaymentStatus.PAID;
    }
}
