package com.LeaseManager.Service.Audit;

import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Entity.User;
import com.LeaseManager.Repository.AuditLogRepository;
import com.LeaseManager.Repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AuditService {

    private final AuditLogRepository auditLogRepository;
    private final UserRepository userRepository;

    public AuditService(AuditLogRepository auditLogRepository, UserRepository userRepository) {
        this.auditLogRepository = auditLogRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public void log(Long userId, AuditLog.AuditAction action, String entityType, Long entityId,
                    String description, String ipAddress) {
        User user = null;
        String username = "system";

        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                username = user.getUsername();
            }
        }

        AuditLog log = AuditLog.builder()
                .user(user)
                .username(username)
                .action(action)
                .entityType(entityType)
                .entityId(entityId)
                .description(description)
                .ipAddress(ipAddress)
                .timestamp(LocalDateTime.now())
                .build();

        auditLogRepository.save(log);
    }

    @Transactional
    public void logWithChanges(Long userId, AuditLog.AuditAction action, String entityType, Long entityId,
                               String description, String oldValue, String newValue, String ipAddress) {
        User user = null;
        String username = "system";

        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                username = user.getUsername();
            }
        }

        AuditLog log = AuditLog.builder()
                .user(user)
                .username(username)
                .action(action)
                .entityType(entityType)
                .entityId(entityId)
                .description(description)
                .oldValue(oldValue)
                .newValue(newValue)
                .ipAddress(ipAddress)
                .timestamp(LocalDateTime.now())
                .build();

        auditLogRepository.save(log);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> getAllLogs(Pageable pageable) {
        return auditLogRepository.findAllByOrderByTimestampDesc(pageable);
    }

    @Transactional(readOnly = true)
    public List<AuditLog> getLogsByUser(Long userId) {
        return auditLogRepository.findByUserId(userId);
    }

    @Transactional(readOnly = true)
    public List<AuditLog> getLogsByEntity(String entityType, Long entityId) {
        return auditLogRepository.findByEntityTypeAndEntityId(entityType, entityId);
    }

    @Transactional(readOnly = true)
    public List<AuditLog> getLogsByAction(AuditLog.AuditAction action) {
        return auditLogRepository.findByAction(action);
    }

    @Transactional(readOnly = true)
    public List<AuditLog> getLogsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return auditLogRepository.findByDateRange(startDate, endDate);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> getLogsWithFilters(Long userId, AuditLog.AuditAction action, String entityType,
                                             LocalDateTime startDate, LocalDateTime endDate, Pageable pageable) {
        String actionStr = action != null ? action.name() : null;
        String startDateStr = startDate != null ? startDate.toString() : null;
        String endDateStr = endDate != null ? endDate.toString() : null;
        return auditLogRepository.findByFilters(userId, actionStr, entityType, startDateStr, endDateStr, pageable);
    }
}
