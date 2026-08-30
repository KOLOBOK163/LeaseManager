package com.LeaseManager.Dto.Payment;

import com.LeaseManager.Entity.Payment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponse {

    private Long id;
    private Long scheduleId;
    private Long contractId;
    private String contractNumber;
    private Integer periodNumber;
    private BigDecimal amount;
    private LocalDateTime dueDate;
    private LocalDateTime paidDate;
    private Payment.PaymentType paymentType;
    private Payment.PaymentMethod paymentMethod;
    private Payment.PaymentStatus status;
    private String comment;
    private String documentNumber;
    private LocalDateTime createdAt;
}
