package com.LeaseManager.Dto.Client;

import com.LeaseManager.Entity.Client;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateClientRequest {

    // Общие поля
    @NotBlank(message = "ФИО обязательно для заполнения")
    private String fullName;

    private String phoneNumber;

    @Email(message = "Некорректный формат email")
    private String email;

    @NotNull(message = "Тип клиента обязателен")
    private Client.ClientType clientType;

    private String inn;

    // Поля для физических лиц
    private String passportSeries;
    private String passportNumber;
    private String passportIssuedBy;
    private LocalDate passportIssueDate;
    private String passportDepartmentCode;
    private String registrationAddress;
    private LocalDate birthDate;

    // Поля для юридических лиц
    private String companyName;
    private String kpp;
    private String ogrn;
    private String legalAddress;
    private String actualAddress;
    private String contactPersonPosition;

    // Банковские реквизиты
    private String bankAccount;
    private String bik;
    private String bankName;
}
