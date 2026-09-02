package com.LeaseManager.Dto.Payment;

import com.LeaseManager.Entity.Payment;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
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
public class RegisterPaymentRequest {

    @NotNull(message = "ID графика платежа обязателен")
    private Long scheduleId;

    @NotNull(message = "Сумма платежа обязательна")
    @DecimalMin(value = "0.01", message = "Сумма должна быть больше 0")
    private BigDecimal amount;

    @NotNull(message = "Дата платежа обязательна")
    private LocalDateTime paymentDate;

    private Payment.PaymentType paymentType = Payment.PaymentType.PRINCIPAL;

    private Payment.PaymentMethod paymentMethod;

    private String comment;

    private String documentNumber;
}
