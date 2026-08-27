package com.LeaseManager.Dto.Contract;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GeneratePaymentScheduleRequest {

    @NotNull(message = "ID договора обязателен")
    private Long contractId;

    @Min(value = 1, message = "Количество периодов должно быть больше 0")
    private Integer periods;
}
