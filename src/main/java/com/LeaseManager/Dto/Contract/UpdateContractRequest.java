package com.LeaseManager.Dto.Contract;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class UpdateContractRequest {

    @NotBlank(message = "Номер договора обязателен")
    private String contractNumber;

    @NotNull(message = "Клиент обязателен")
    private Long clientId;

    @NotNull(message = "Оборудование обязательно")
    private Long equipmentId;

    @NotNull(message = "Дата начала обязательна")
    private LocalDate startDate;

    @NotNull(message = "Дата окончания обязательна")
    private LocalDate endDate;

    @NotNull(message = "Сумма обязательна")
    @DecimalMin(value = "0.01", message = "Сумма должна быть больше 0")
    private BigDecimal totalAmount;

    private String description;

    @DecimalMin(value = "0", message = "Процентная ставка не может быть отрицательной")
    private BigDecimal interestRate;

    @Min(value = 1, message = "Период должен быть не менее 1 месяца")
    private Integer periodMonths;
}
