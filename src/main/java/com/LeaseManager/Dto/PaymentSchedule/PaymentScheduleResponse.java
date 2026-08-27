package com.LeaseManager.Dto.PaymentSchedule;

import com.LeaseManager.Entity.PaymentScheduleStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PaymentScheduleResponse {
    private Long id;
    private Long contractId;
    private Integer periodNumber;
    private LocalDate paymentDate;
    private BigDecimal totalAmount;
    private BigDecimal principalPart;
    private BigDecimal interestPart;
    private PaymentScheduleStatus status;
    private boolean overdue;
}
