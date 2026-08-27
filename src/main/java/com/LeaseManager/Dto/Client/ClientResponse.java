package com.LeaseManager.Dto.Client;

import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.Contract;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ClientResponse {
    private Long id;

    // Общие поля
    private String fullName;
    private String phoneNumber;
    private String email;
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

    // Служебные поля
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    private List<ContractInfo> contracts;

    @Getter
    @Setter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class ContractInfo {
        private Long id;
        private String contractNumber;
        private LocalDate startDate;
        private LocalDate endDate;
        private BigDecimal totalAmount;
        private Contract.ContractStatus status;
    }
}
