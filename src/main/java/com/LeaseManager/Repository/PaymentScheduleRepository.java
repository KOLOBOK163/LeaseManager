package com.LeaseManager.Repository;

import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * Репозиторий для работы с графиками платежей
 */
@Repository
public interface PaymentScheduleRepository extends JpaRepository<PaymentSchedule, Long> {

    /**
     * Поиск графиков платежей по договору
     */
    List<PaymentSchedule> findByContractId(Long contractId);

    /**
     * Поиск графиков платежей по статусу
     */
    List<PaymentSchedule> findByStatus(PaymentScheduleStatus status);

    /**
     * Поиск всех графиков платежей по статусу
     */
    List<PaymentSchedule> findAllByStatus(PaymentScheduleStatus status);

    /**
     * Поиск просроченных графиков платежей
     */
    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate < :currentDate AND ps.status NOT IN (:excludedStatuses)")
    List<PaymentSchedule> findOverdueSchedules(@Param("currentDate") LocalDate currentDate,
                                               @Param("excludedStatuses") List<PaymentScheduleStatus> excludedStatuses);

    /**
     * Поиск графиков платежей по периоду
     */
    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate BETWEEN :startDate AND :endDate ORDER BY ps.paymentDate")
    List<PaymentSchedule> findByPeriod(@Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate);

    /**
     * Поиск ожидающих платежей до определенной даты
     */
    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate <= :date AND ps.status = :status ORDER BY ps.paymentDate")
    List<PaymentSchedule> findPendingByDate(@Param("date") LocalDate date,
                                            @Param("status") PaymentScheduleStatus status);

    /**
     * Проверка наличия неоплаченных графиков по договору
     */
    @Query("SELECT COUNT(ps) > 0 FROM PaymentSchedule ps WHERE ps.contract.id = :contractId AND ps.status NOT IN (:excludedStatuses)")
    boolean hasUnpaidSchedules(@Param("contractId") Long contractId,
                               @Param("excludedStatuses") List<PaymentScheduleStatus> excludedStatuses);

    /**
     * Удаление всех графиков платежей по договору
     */
    void deleteByContractId(Long contractId);
}
