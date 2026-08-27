package com.LeaseManager.Dto.PaymentSchedule;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
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
public class CreatePaymentScheduleRequest {

    @NotNull(message = "ID договора обязателен")
    private Long contractId;

    @Min(value = 1, message = "Номер периода должен быть больше 0")
    private Integer periodNumber;

    @NotNull(message = "Дата платежа обязательна")
    private LocalDate paymentDate;

    @NotNull(message = "Сумма обязательна")
    @DecimalMin(value = "0.01", message = "Сумма должна быть больше 0")
    private BigDecimal totalAmount;

    @NotNull(message = "Сумма основного долга обязательна")
    @DecimalMin(value = "0.01", message = "Сумма основного долга должна быть больше 0")
    private BigDecimal principalPart;

    @NotNull(message = "Сумма процентов обязательна")
    @DecimalMin(value = "0.01", message = "Сумма процентов должна быть больше 0")
    private BigDecimal interestPart;
}
