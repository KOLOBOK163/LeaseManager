package com.LeaseManager.Dto;

import com.LeaseManager.Entity.Payment;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
public class PaymentDto {
    private Long id;

    private Long contractId;

    private Long scheduleId;

    private BigDecimal amount;

    private LocalDateTime dueDate;

    private Payment.PaymentType paymentType;

    private String comment;
}
