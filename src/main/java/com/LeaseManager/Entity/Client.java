package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Клиент (физическое или юридическое лицо)
 */
@Entity
@Table(name = "clients")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Общие поля
    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(name = "email", length = 100)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "client_type", length = 20)
    private ClientType clientType;

    @Column(name = "inn", length = 20)
    private String inn;

    // Поля для физических лиц
    @Column(name = "passport_series", length = 10)
    private String passportSeries;

    @Column(name = "passport_number", length = 20)
    private String passportNumber;

    @Column(name = "passport_issued_by", length = 500)
    private String passportIssuedBy;

    @Column(name = "passport_issue_date")
    private LocalDate passportIssueDate;

    @Column(name = "passport_department_code", length = 10)
    private String passportDepartmentCode;

    @Column(name = "registration_address", length = 500)
    private String registrationAddress;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    // Поля для юридических лиц
    @Column(name = "company_name", length = 255)
    private String companyName;

    @Column(name = "kpp", length = 20)
    private String kpp;

    @Column(name = "ogrn", length = 20)
    private String ogrn;

    @Column(name = "legal_address", length = 500)
    private String legalAddress;

    @Column(name = "actual_address", length = 500)
    private String actualAddress;

    @Column(name = "contact_person_position", length = 100)
    private String contactPersonPosition;

    // Банковские реквизиты (для обоих типов)
    @Column(name = "bank_account", length = 20)
    private String bankAccount;

    @Column(name = "bik", length = 9)
    private String bik;

    @Column(name = "bank_name", length = 255)
    private String bankName;

    // Служебные поля
    @Column(name = "created_date", nullable = false)
    @Builder.Default
    private LocalDateTime createdDate = LocalDateTime.now();

    @Column(name = "updated_date")
    private LocalDateTime updatedDate;

    public enum ClientType {
        INDIVIDUAL,     // Физическое лицо
        LEGAL_ENTITY    // Юридическое лицо
    }
}
