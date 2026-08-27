package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Журнал аудита действий пользователей
 */
@Entity
@Table(name = "audit_log")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", foreignKey = @ForeignKey(name = "fk_audit_user"))
    private User user;

    @Column(name = "username", length = 100)
    private String username;

    @Enumerated(EnumType.STRING)
    @Column(name = "action", nullable = false, length = 50)
    private AuditAction action;

    @Column(name = "entity_type", length = 100)
    private String entityType;

    @Column(name = "entity_id")
    private Long entityId;

    @Column(name = "description", length = 1000)
    private String description;

    @Column(name = "old_value", columnDefinition = "TEXT")
    private String oldValue;

    @Column(name = "new_value", columnDefinition = "TEXT")
    private String newValue;

    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(name = "timestamp", nullable = false)
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();

    /**
     * Типы действий для аудита
     */
    public enum AuditAction {
        CREATE,         // Создание
        UPDATE,         // Обновление
        DELETE,         // Удаление
        LOGIN,          // Вход в систему
        LOGOUT,         // Выход из системы
        STATUS_CHANGE,  // Изменение статуса
        APPROVE,        // Одобрение
        REJECT,         // Отклонение
        EXPORT,         // Экспорт данных
        VIEW            // Просмотр
    }
}
