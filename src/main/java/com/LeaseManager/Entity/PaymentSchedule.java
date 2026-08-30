package com.LeaseManager.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "payment_schedules")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PaymentSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference("contract-paymentSchedules")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contract_id", nullable = false, foreignKey = @ForeignKey(name = "fk_payment_schedule_contract"))
    private Contract contract;

    @Column(name = "period_number", nullable = false)
    private Integer periodNumber;

    @Column(name = "payment_date", nullable = false)
    private LocalDate paymentDate;

    @Column(name = "total_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "principal_part", nullable = false, precision = 15, scale = 2)
    private BigDecimal principalPart;

    @Column(name = "interest_part", nullable = false, precision = 15, scale = 2)
    private BigDecimal interestPart;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private PaymentScheduleStatus status = PaymentScheduleStatus.PENDING;

    @JsonManagedReference("schedule-payments")
    @OneToMany(mappedBy = "schedule", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Payment> payments = new ArrayList<>();

    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setSchedule(this);
    }

    public void removePayment(Payment payment) {
        payments.remove(payment);
        payment.setSchedule(null);
    }

    public boolean isPartiallyPaid() {
        return status == PaymentScheduleStatus.PARTIAL;
    }

    public boolean isFullyPaid() {
        return status == PaymentScheduleStatus.PAID;
    }

    public boolean isOverdue() {
        return status == PaymentScheduleStatus.OVERDUE;
    }
}
