package com.LeaseManager.Service.Insurance;

import com.LeaseManager.Dto.Contract.InsuranceDto;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.User;
import com.LeaseManager.Entity.UserRole;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.UserRepository;
import com.LeaseManager.Service.Notification.EmailService;
import jakarta.persistence.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Сервис для управления страхованием оборудования
 */
@Service
public class InsuranceService {

    private static final Logger logger = LoggerFactory.getLogger(InsuranceService.class);

    private final ContractRepository contractRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Value("${notification.manager.emails:}")
    private String managerEmails;

    public InsuranceService(ContractRepository contractRepository,
                           UserRepository userRepository,
                           EmailService emailService) {
        this.contractRepository = contractRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
    }

    /**
     * Добавить страхование к договору
     */
    @Transactional
    public Contract addInsurance(Long contractId, InsuranceDto insuranceDto) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));

        contract.setInsurancePolicyNumber(insuranceDto.getInsurancePolicyNumber());
        contract.setInsuranceCompany(insuranceDto.getInsuranceCompany());
        contract.setInsurancePremiumAnnual(insuranceDto.getInsurancePremiumAnnual());
        contract.setInsurancePremiumMonthly(insuranceDto.getInsurancePremiumMonthly());
        contract.setInsuranceStartDate(insuranceDto.getInsuranceStartDate());
        contract.setInsuranceExpiryDate(insuranceDto.getInsuranceExpiryDate());
        contract.setInsuranceCoverageAmount(insuranceDto.getInsuranceCoverageAmount());
        contract.setInsuranceType(insuranceDto.getInsuranceType());

        return contractRepository.save(contract);
    }

    /**
     * Обновить страхование
     */
    @Transactional
    public Contract updateInsurance(Long contractId, InsuranceDto insuranceDto) {
        return addInsurance(contractId, insuranceDto);
    }

    /**
     * Получить информацию о страховании
     */
    @Transactional(readOnly = true)
    public InsuranceDto getInsurance(Long contractId) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));

        return InsuranceDto.builder()
                .insurancePolicyNumber(contract.getInsurancePolicyNumber())
                .insuranceCompany(contract.getInsuranceCompany())
                .insurancePremiumAnnual(contract.getInsurancePremiumAnnual())
                .insurancePremiumMonthly(contract.getInsurancePremiumMonthly())
                .insuranceStartDate(contract.getInsuranceStartDate())
                .insuranceExpiryDate(contract.getInsuranceExpiryDate())
                .insuranceCoverageAmount(contract.getInsuranceCoverageAmount())
                .insuranceType(contract.getInsuranceType())
                .build();
    }

    /**
     * Рассчитать страховую премию на основе стоимости оборудования
     *
     * Тарифы:
     * - Холодильное оборудование: 2.5%
     * - Кассовое оборудование: 1.5%
     * - Торговые витрины: 3%
     * - Прочее: 2%
     */
    public BigDecimal calculateInsurancePremium(Equipment equipment) {
        BigDecimal equipmentPrice = equipment.getPrice();
        BigDecimal rate;

        if (equipment.getEquipmentType() != null) {
            switch (equipment.getEquipmentType()) {
                case REFRIGERATOR:
                case FREEZER:
                case COOLER:
                    rate = BigDecimal.valueOf(0.025); // 2.5%
                    break;
                case CASH_REGISTER:
                case TERMINAL:
                    rate = BigDecimal.valueOf(0.015); // 1.5%
                    break;
                case SHOWCASE:
                case HEAT_DISPLAY:
                    rate = BigDecimal.valueOf(0.03); // 3%
                    break;
                default:
                    rate = BigDecimal.valueOf(0.02); // 2%
            }
        } else {
            rate = BigDecimal.valueOf(0.02); // 2% по умолчанию
        }

        return equipmentPrice.multiply(rate).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Рассчитать ежемесячную страховую премию
     */
    public BigDecimal calculateMonthlyPremium(BigDecimal annualPremium) {
        return annualPremium.divide(BigDecimal.valueOf(12), 2, RoundingMode.HALF_UP);
    }

    /**
     * Проверить истечение срока страхования
     * Запускается каждый день в 8:00
     */
    @Scheduled(cron = "0 0 8 * * ?")
    @Transactional(readOnly = true)
    public void checkExpiringInsurance() {
        logger.info("Запуск проверки истекающих страховок");

        LocalDate today = LocalDate.now();
        LocalDate thirtyDaysLater = today.plusDays(30);

        List<Contract> allContracts = contractRepository.findAll();
        int notificationsSent = 0;

        for (Contract contract : allContracts) {
            if (contract.getInsuranceExpiryDate() != null &&
                contract.getStatus() == Contract.ContractStatus.ACTIVE) {

                LocalDate expiryDate = contract.getInsuranceExpiryDate();

                // Уведомление за 30 дней
                if (expiryDate.isAfter(today) && expiryDate.isBefore(thirtyDaysLater)) {
                    sendInsuranceExpiryNotification(contract);
                    notificationsSent++;
                }

                // Уведомление о просроченной страховке
                if (expiryDate.isBefore(today)) {
                    sendInsuranceExpiredNotification(contract);
                    notificationsSent++;
                }
            }
        }

        logger.info("Отправлено {} уведомлений об истечении страховок", notificationsSent);
    }

    /**
     * Получить список email-адресов менеджеров и администраторов
     */
    private List<String> getManagerEmails() {
        // Получаем всех активных менеджеров
        List<User> managers = userRepository.findAll().stream()
                .filter(user -> user.getActive() != null && user.getActive())
                .filter(user -> user.getRole() == UserRole.MANAGER)
                .collect(Collectors.toList());

        List<String> emails = managers.stream()
                .map(User::getEmail)
                .filter(email -> email != null && !email.isEmpty())
                .collect(Collectors.toList());

        if (managerEmails != null && !managerEmails.isEmpty()) {
            String[] additionalEmails = managerEmails.split(",");
            for (String email : additionalEmails) {
                String trimmed = email.trim();
                if (!trimmed.isEmpty() && !emails.contains(trimmed)) {
                    emails.add(trimmed);
                }
            }
        }

        return emails;
    }

    /**
     * Отправить уведомление менеджерам об истечении страховки
     */
    private void sendInsuranceExpiryNotification(Contract contract) {
        List<String> managerEmails = getManagerEmails();

        if (managerEmails.isEmpty()) {
            logger.warn("Не найдены email-адреса менеджеров для отправки уведомлений");
            return;
        }

        long daysUntilExpiry = java.time.temporal.ChronoUnit.DAYS.between(
                LocalDate.now(), contract.getInsuranceExpiryDate());

        String clientName = contract.getClient().getFullName();
        if (clientName == null || clientName.isEmpty()) {
            clientName = contract.getClient().getCompanyName();
        }

        String clientPhone = contract.getClient().getPhoneNumber();
        String clientEmail = contract.getClient().getEmail();
        String contactInfo = "";
        if (clientPhone != null && !clientPhone.isEmpty()) {
            contactInfo += "Телефон: " + clientPhone + "\n            ";
        }
        if (clientEmail != null && !clientEmail.isEmpty()) {
            contactInfo += "Email: " + clientEmail;
        }

        String subject = "Напоминание: истекает срок страхования по договору " + contract.getContractNumber();
        String body = String.format("""
            Уважаемые коллеги!

            Напоминаем, что срок действия страхового полиса истекает через %d дн.

            Клиент: %s
            %s

            Номер договора: %s
            Номер полиса: %s
            Страховая компания: %s
            Дата окончания: %s
            Сумма покрытия: %.2f руб.

            ТРЕБУЕТСЯ:
            1. Связаться с клиентом для напоминания о продлении страховки
            2. Проконтролировать своевременное продление полиса
            3. Получить копию нового полиса после продления

            ---
            Система управления лизингом LeaseManager
            """,
            daysUntilExpiry,
            clientName,
            contactInfo,
            contract.getContractNumber(),
            contract.getInsurancePolicyNumber(),
            contract.getInsuranceCompany(),
            contract.getInsuranceExpiryDate(),
            contract.getInsuranceCoverageAmount() != null ? contract.getInsuranceCoverageAmount() : BigDecimal.ZERO
        );

        try {
            emailService.sendEmailToMultiple(managerEmails.toArray(new String[0]), subject, body);
            logger.info("Отправлено уведомление об истечении страховки {} менеджерам для договора {}",
                       managerEmails.size(), contract.getContractNumber());
        } catch (Exception e) {
            logger.error("Ошибка отправки уведомления о страховке: {}", e.getMessage());
        }
    }

    /**
     * Отправить уведомление менеджерам о просроченной страховке
     */
    private void sendInsuranceExpiredNotification(Contract contract) {
        List<String> managerEmails = getManagerEmails();

        if (managerEmails.isEmpty()) {
            logger.warn("Не найдены email-адреса менеджеров для отправки уведомлений");
            return;
        }

        long daysOverdue = java.time.temporal.ChronoUnit.DAYS.between(
                contract.getInsuranceExpiryDate(), LocalDate.now());

        String clientName = contract.getClient().getFullName();
        if (clientName == null || clientName.isEmpty()) {
            clientName = contract.getClient().getCompanyName();
        }

        String clientPhone = contract.getClient().getPhoneNumber();
        String clientEmail = contract.getClient().getEmail();
        String contactInfo = "";
        if (clientPhone != null && !clientPhone.isEmpty()) {
            contactInfo += "Телефон: " + clientPhone + "\n            ";
        }
        if (clientEmail != null && !clientEmail.isEmpty()) {
            contactInfo += "Email: " + clientEmail;
        }

        String subject = "ВНИМАНИЕ: Просрочена страховка по договору " + contract.getContractNumber();
        String body = String.format("""
            ВНИМАНИЕ! Обнаружена просрочка страхования!

            Клиент: %s
            %s

            Номер договора: %s
            Номер полиса: %s
            Дата окончания: %s (просрочено на %d дн.)
            Страховая компания: %s

            Согласно условиям договора, оборудование должно быть застраховано на весь период лизинга.

            ТРЕБУЕТСЯ СРОЧНО:
            1. Связаться с клиентом
            2. Потребовать немедленного продления страхования
            3. Рассмотреть возможность приостановки договора при отказе
            4. Получить копию нового полиса

            ---
            Система управления лизингом LeaseManager
            """,
            clientName,
            contactInfo,
            contract.getContractNumber(),
            contract.getInsurancePolicyNumber(),
            contract.getInsuranceExpiryDate(),
            daysOverdue,
            contract.getInsuranceCompany()
        );

        try {
            emailService.sendEmailToMultiple(managerEmails.toArray(new String[0]), subject, body);
            logger.info("Отправлено уведомление о просроченной страховке {} менеджерам для договора {}",
                       managerEmails.size(), contract.getContractNumber());
        } catch (Exception e) {
            logger.error("Ошибка отправки уведомления о просроченной страховке: {}", e.getMessage());
        }
    }

    /**
     * Получить список договоров с истекающей страховкой
     */
    @Transactional(readOnly = true)
    public List<Contract> getContractsWithExpiringInsurance(int daysAhead) {
        LocalDate today = LocalDate.now();
        LocalDate futureDate = today.plusDays(daysAhead);

        return contractRepository.findAll().stream()
                .filter(c -> c.getInsuranceExpiryDate() != null)
                .filter(c -> c.getInsuranceExpiryDate().isAfter(today) &&
                           c.getInsuranceExpiryDate().isBefore(futureDate))
                .filter(c -> c.getStatus() == Contract.ContractStatus.ACTIVE)
                .toList();
    }

    /**
     * Получить список договоров с просроченной страховкой
     */
    @Transactional(readOnly = true)
    public List<Contract> getContractsWithExpiredInsurance() {
        LocalDate today = LocalDate.now();

        return contractRepository.findAll().stream()
                .filter(c -> c.getInsuranceExpiryDate() != null)
                .filter(c -> c.getInsuranceExpiryDate().isBefore(today))
                .filter(c -> c.getStatus() == Contract.ContractStatus.ACTIVE)
                .toList();
    }
}
