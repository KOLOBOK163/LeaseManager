package com.LeaseManager.Repository;

import com.LeaseManager.Entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Репозиторий для работы с платежами
 */
@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    /**
     * Поиск платежей по договору
     */
    List<Payment> findByContractId(Long contractId);

    /**
     * Поиск платежей по графику платежей
     */
    List<Payment> findByScheduleId(Long scheduleId);

    /**
     * Поиск платежей по статусу
     */
    List<Payment> findByStatus(Payment.PaymentStatus status);

    /**
     * Поиск всех платежей по статусу
     */
    List<Payment> findAllByStatus(Payment.PaymentStatus status);

    /**
     * Поиск просроченных платежей
     */
    @Query("SELECT p FROM Payment p WHERE p.dueDate < :currentDate AND p.status NOT IN (:excludedStatuses)")
    List<Payment> findOverduePayments(@Param("currentDate") LocalDateTime currentDate,
                                      @Param("excludedStatuses") List<Payment.PaymentStatus> excludedStatuses);

    /**
     * Поиск платежей по периоду
     */
    @Query("SELECT p FROM Payment p WHERE p.dueDate BETWEEN :startDate AND :endDate ORDER BY p.dueDate")
    List<Payment> findByPeriod(@Param("startDate") LocalDateTime startDate,
                               @Param("endDate") LocalDateTime endDate);

    /**
     * Поиск ожидающих платежей по договору
     */
    @Query("SELECT p FROM Payment p WHERE p.contract.id = :contractId AND p.status = :status")
    List<Payment> findPendingByContract(@Param("contractId") Long contractId,
                                        @Param("status") Payment.PaymentStatus status);
}
