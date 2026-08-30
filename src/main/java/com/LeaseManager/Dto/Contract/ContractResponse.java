package com.LeaseManager.Dto.Contract;


import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContractResponse {
    private long id;
    private String contractNumber;
    private String clientName;
    private long clientId;
    private long equipmentId;
    private BigDecimal totalAmount;
    private BigDecimal interestRate;
    private int paymentPeriodMonths;
    private String status;
    private LocalDate startDate;
    private LocalDate endDate;

}
