package com.LeaseManager.Repository;

import com.LeaseManager.Entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    List<AuditLog> findByUserId(Long userId);

    List<AuditLog> findByEntityTypeAndEntityId(String entityType, Long entityId);

    List<AuditLog> findByAction(AuditLog.AuditAction action);

    Page<AuditLog> findAllByOrderByTimestampDesc(Pageable pageable);

    @Query("SELECT a FROM AuditLog a WHERE a.timestamp BETWEEN :startDate AND :endDate ORDER BY a.timestamp DESC")
    List<AuditLog> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                    @Param("endDate") LocalDateTime endDate);

    @Query(value = "SELECT * FROM audit_log a WHERE " +
           "(:userId IS NULL OR a.user_id = :userId) AND " +
           "(:action IS NULL OR a.action = :action) AND " +
           "(:entityType IS NULL OR a.entity_type = :entityType) AND " +
           "(:startDate IS NULL OR a.timestamp >= CAST(:startDate AS TIMESTAMP)) AND " +
           "(:endDate IS NULL OR a.timestamp <= CAST(:endDate AS TIMESTAMP)) " +
           "ORDER BY a.timestamp DESC",
           countQuery = "SELECT COUNT(*) FROM audit_log a WHERE " +
           "(:userId IS NULL OR a.user_id = :userId) AND " +
           "(:action IS NULL OR a.action = :action) AND " +
           "(:entityType IS NULL OR a.entity_type = :entityType) AND " +
           "(:startDate IS NULL OR a.timestamp >= CAST(:startDate AS TIMESTAMP)) AND " +
           "(:endDate IS NULL OR a.timestamp <= CAST(:endDate AS TIMESTAMP))",
           nativeQuery = true)
    Page<AuditLog> findByFilters(@Param("userId") Long userId,
                                  @Param("action") String action,
                                  @Param("entityType") String entityType,
                                  @Param("startDate") String startDate,
                                  @Param("endDate") String endDate,
                                  Pageable pageable);
}
