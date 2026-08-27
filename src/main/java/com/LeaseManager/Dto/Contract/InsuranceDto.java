package com.LeaseManager.Dto.Contract;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InsuranceDto {

    private String insurancePolicyNumber;
    private String insuranceCompany;
    private BigDecimal insurancePremiumAnnual;
    private BigDecimal insurancePremiumMonthly;
    private LocalDate insuranceStartDate;
    private LocalDate insuranceExpiryDate;
    private BigDecimal insuranceCoverageAmount;
    private String insuranceType;
}
