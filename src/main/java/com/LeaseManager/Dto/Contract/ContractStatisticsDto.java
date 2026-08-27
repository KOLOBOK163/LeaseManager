package com.LeaseManager.Dto.Contract;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContractStatisticsDto {
    private BigDecimal totalAmount;        // Общая сумма договора
    private BigDecimal paidAmount;         // Сумма оплачено
    private BigDecimal remainingAmount;    // Остаток долга
    private Integer totalPayments;         // Всего платежей
    private Integer paidPayments;          // Оплачено платежей
    private Integer overduePayments;       // Просроченных платежей
}
