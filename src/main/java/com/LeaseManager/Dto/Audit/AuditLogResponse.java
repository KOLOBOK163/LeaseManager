package com.LeaseManager.Dto.Audit;

import com.LeaseManager.Entity.AuditLog;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuditLogResponse {
    private Long id;
    private Long userId;
    private String username;
    private AuditLog.AuditAction action;
    private String entityType;
    private Long entityId;
    private String description;
    private String oldValue;
    private String newValue;
    private String ipAddress;
    private LocalDateTime timestamp;
}
