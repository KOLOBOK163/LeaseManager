package com.LeaseManager.Service.Notification;

import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Entity.User;
import com.LeaseManager.Entity.UserRole;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import com.LeaseManager.Repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    private final PaymentScheduleRepository paymentScheduleRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Value("${notification.manager.emails:}")
    private String managerEmails;

    public NotificationService(PaymentScheduleRepository paymentScheduleRepository,
                              UserRepository userRepository,
                              EmailService emailService) {
        this.paymentScheduleRepository = paymentScheduleRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
    }

    private List<String> getManagerEmails() {
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

    public void sendUpcomingPaymentNotification(PaymentSchedule schedule) {
        List<String> managerEmails = getManagerEmails();

        if (managerEmails.isEmpty()) {
            logger.warn("Не найдены email-адреса менеджеров для отправки уведомлений");
            return;
        }

        Contract contract = schedule.getContract();
        String subject = "Напоминание: предстоящий платёж по договору " + contract.getContractNumber();
        String body = buildUpcomingPaymentEmailForManagers(schedule);

        emailService.sendEmailToMultiple(managerEmails.toArray(new String[0]), subject, body);
        logger.info("Отправлено уведомление о предстоящем платеже {} менеджерам для договора {}",
                    managerEmails.size(), contract.getContractNumber());
    }

    public void sendOverduePaymentNotification(PaymentSchedule schedule) {
        List<String> managerEmails = getManagerEmails();

        if (managerEmails.isEmpty()) {
            logger.warn("Не найдены email-адреса менеджеров для отправки уведомлений");
            return;
        }

        Contract contract = schedule.getContract();
        String subject = "ВНИМАНИЕ: Просрочен платёж по договору " + contract.getContractNumber();
        String body = buildOverduePaymentEmailForManagers(schedule);

        emailService.sendEmailToMultiple(managerEmails.toArray(new String[0]), subject, body);
        logger.info("Отправлено уведомление о просроченном платеже {} менеджерам для договора {}",
                    managerEmails.size(), contract.getContractNumber());
    }

    @Scheduled(cron = "0 0 9 * * ?")
    @Transactional
    public void checkUpcomingPayments() {
        logger.info("Запуск проверки предстоящих платежей");

        LocalDate today = LocalDate.now();
        LocalDate threeDaysLater = today.plusDays(3);

        // Получаем платежи на ближайшие 3 дня
        List<PaymentSchedule> upcomingSchedules = paymentScheduleRepository.findByPeriod(today, threeDaysLater);

        int sentCount = 0;
        for (PaymentSchedule schedule : upcomingSchedules) {
            if (schedule.getStatus() == PaymentScheduleStatus.PENDING) {
                try {
                    sendUpcomingPaymentNotification(schedule);
                    sentCount++;
                } catch (Exception e) {
                    logger.error("Ошибка отправки уведомления для графика {}: {}", schedule.getId(), e.getMessage());
                }
            }
        }

        logger.info("Отправлено {} уведомлений о предстоящих платежах", sentCount);
    }

    @Scheduled(cron = "0 0 10 * * ?")
    @Transactional
    public void checkOverduePayments() {
        logger.info("Запуск проверки просроченных платежей");

        List<PaymentSchedule> overdueSchedules = paymentScheduleRepository.findAllByStatus(PaymentScheduleStatus.OVERDUE);

        int sentCount = 0;
        for (PaymentSchedule schedule : overdueSchedules) {
            try {
                sendOverduePaymentNotification(schedule);
                sentCount++;
            } catch (Exception e) {
                logger.error("Ошибка отправки уведомления о просрочке для графика {}: {}", schedule.getId(), e.getMessage());
            }
        }

        logger.info("Отправлено {} уведомлений о просроченных платежах", sentCount);
    }

    private String buildUpcomingPaymentEmailForManagers(PaymentSchedule schedule) {
        Contract contract = schedule.getContract();
        String clientName = contract.getClient().getFullName();
        if (clientName == null || clientName.isEmpty()) {
            clientName = contract.getClient().getCompanyName();
        }

        return String.format("""
            Уважаемые коллеги!

            Напоминаем о предстоящем платеже по договору лизинга.

            Клиент: %s
            Номер договора: %s
            Дата платежа: %s
            Сумма платежа: %.2f руб.
            Период: %d

            Основной долг: %.2f руб.
            Проценты: %.2f руб.

            Рекомендуется связаться с клиентом для напоминания о платеже.

            ---
            Система управления лизингом LeaseManager
            """,
            clientName,
            contract.getContractNumber(),
            schedule.getPaymentDate(),
            schedule.getTotalAmount(),
            schedule.getPeriodNumber(),
            schedule.getPrincipalPart(),
            schedule.getInterestPart()
        );
    }

    private String buildOverduePaymentEmailForManagers(PaymentSchedule schedule) {
        Contract contract = schedule.getContract();
        String clientName = contract.getClient().getFullName();
        if (clientName == null || clientName.isEmpty()) {
            clientName = contract.getClient().getCompanyName();
        }

        long daysOverdue = LocalDate.now().toEpochDay() - schedule.getPaymentDate().toEpochDay();

        String clientPhone = contract.getClient().getPhoneNumber();
        String clientEmail = contract.getClient().getEmail();
        String contactInfo = "";
        if (clientPhone != null && !clientPhone.isEmpty()) {
            contactInfo += "Телефон: " + clientPhone + "\n            ";
        }
        if (clientEmail != null && !clientEmail.isEmpty()) {
            contactInfo += "Email: " + clientEmail;
        }

        return String.format("""
            ВНИМАНИЕ! Обнаружена просрочка платежа!

            Клиент: %s
            %s

            Номер договора: %s
            Дата платежа: %s (просрочено на %d дн.)
            Сумма платежа: %.2f руб.
            Период: %d

            Основной долг: %.2f руб.
            Проценты: %.2f руб.

            ТРЕБУЕТСЯ СРОЧНО:
            1. Связаться с клиентом
            2. Выяснить причину просрочки
            3. Согласовать дату погашения задолженности
            4. При необходимости начислить пени

            ---
            Система управления лизингом LeaseManager
            """,
            clientName,
            contactInfo,
            contract.getContractNumber(),
            schedule.getPaymentDate(),
            daysOverdue,
            schedule.getTotalAmount(),
            schedule.getPeriodNumber(),
            schedule.getPrincipalPart(),
            schedule.getInterestPart()
        );
    }
}
