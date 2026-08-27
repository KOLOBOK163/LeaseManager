package com.LeaseManager.Entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Договор лизинга
 */
@Entity
@Table(name = "contracts")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Contract {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "contract_number", nullable = false, unique = true, length = 50)
    private String contractNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false, foreignKey = @ForeignKey(name = "fk_contract_client"))
    private Client client;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "equipment_id", nullable = false, foreignKey = @ForeignKey(name = "fk_contract_equipment"))
    private Equipment equipment;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Column(name = "total_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "interest_rate", precision = 5, scale = 2)
    private BigDecimal interestRate;

    @Column(name = "payment_period_months")
    private Integer paymentPeriodMonths;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private ContractStatus status = ContractStatus.DRAFT;

    @Column(name = "created_date", nullable = false)
    @Builder.Default
    private LocalDate createdDate = LocalDate.now();

    @Column(name = "description", length = 1000)
    private String description;

    // === Страхование ===

    @Column(name = "insurance_policy_number", length = 100)
    private String insurancePolicyNumber;

    @Column(name = "insurance_company", length = 255)
    private String insuranceCompany;

    @Column(name = "insurance_premium_annual", precision = 15, scale = 2)
    private BigDecimal insurancePremiumAnnual;

    @Column(name = "insurance_premium_monthly", precision = 15, scale = 2)
    private BigDecimal insurancePremiumMonthly;

    @Column(name = "insurance_start_date")
    private LocalDate insuranceStartDate;

    @Column(name = "insurance_expiry_date")
    private LocalDate insuranceExpiryDate;

    @Column(name = "insurance_coverage_amount", precision = 15, scale = 2)
    private BigDecimal insuranceCoverageAmount;

    @Column(name = "insurance_type", length = 50)
    private String insuranceType;

    // === Техническое обслуживание ===

    @Column(name = "maintenance_provider", length = 255)
    private String maintenanceProvider;

    @Column(name = "maintenance_fee_monthly", precision = 15, scale = 2)
    private BigDecimal maintenanceFeeMonthly;

    @Column(name = "maintenance_included")
    @Builder.Default
    private Boolean maintenanceIncluded = false;

    @JsonManagedReference("contract-paymentSchedules")
    @OneToMany(mappedBy = "contract", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PaymentSchedule> paymentSchedules = new ArrayList<>();

    @JsonManagedReference("contract-payments")
    @OneToMany(mappedBy = "contract", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Payment> payments = new ArrayList<>();

    /**
     * Добавление графика платежей
     */
    public void addPaymentSchedule(PaymentSchedule schedule) {
        paymentSchedules.add(schedule);
        schedule.setContract(this);
    }

    /**
     * Удаление графика платежей
     */
    public void removePaymentSchedule(PaymentSchedule schedule) {
        paymentSchedules.remove(schedule);
        schedule.setContract(null);
    }

    /**
     * Добавление платежа
     */
    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setContract(this);
    }

    /**
     * Удаление платежа
     */
    public void removePayment(Payment payment) {
        payments.remove(payment);
        payment.setContract(null);
    }

    /**
     * Статусы договора
     */
    public enum ContractStatus {
        DRAFT,      // Черновик
        ACTIVE,     // Активен
        SUSPENDED,  // Приостановлен
        CLOSED,     // Закрыт
        CANCELLED   // Отменен
    }
}
