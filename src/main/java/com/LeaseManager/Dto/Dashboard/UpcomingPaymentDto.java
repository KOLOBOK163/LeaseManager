package com.LeaseManager.Dto.Dashboard;

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
public class UpcomingPaymentDto {
    private Long paymentScheduleId;
    private Long contractId;
    private String contractNumber;
    private String clientName;
    private LocalDate paymentDate;
    private BigDecimal amount;
    private String status;
}
