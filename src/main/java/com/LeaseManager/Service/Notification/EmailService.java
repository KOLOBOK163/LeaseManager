package com.LeaseManager.Service.Notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

/**
 * Сервис для отправки email-уведомлений
 */
@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@leasemanager.com}")
    private String fromEmail;

    @Value("${notification.email.enabled:false}")
    private boolean emailEnabled;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    /**
     * Отправить email
     */
    public void sendEmail(String to, String subject, String body) {
        if (!emailEnabled) {
            logger.info("Email отправка отключена. Письмо не отправлено: {} -> {}", to, subject);
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(body);

            mailSender.send(message);
            logger.info("Email успешно отправлен: {} -> {}", to, subject);
        } catch (Exception e) {
            logger.error("Ошибка отправки email на {}: {}", to, e.getMessage());
            throw new RuntimeException("Не удалось отправить email", e);
        }
    }

    /**
     * Отправить email нескольким получателям
     */
    public void sendEmailToMultiple(String[] recipients, String subject, String body) {
        if (!emailEnabled) {
            logger.info("Email отправка отключена. Письма не отправлены: {}", (Object) recipients);
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(recipients);
            message.setSubject(subject);
            message.setText(body);

            mailSender.send(message);
            logger.info("Email успешно отправлен {} получателям", recipients.length);
        } catch (Exception e) {
            logger.error("Ошибка отправки email: {}", e.getMessage());
            throw new RuntimeException("Не удалось отправить email", e);
        }
    }
}
