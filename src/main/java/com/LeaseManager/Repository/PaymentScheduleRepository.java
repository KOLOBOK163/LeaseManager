package com.LeaseManager.Repository;

import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PaymentScheduleRepository extends JpaRepository<PaymentSchedule, Long> {

    List<PaymentSchedule> findByContractId(Long contractId);

    List<PaymentSchedule> findByStatus(PaymentScheduleStatus status);

    List<PaymentSchedule> findAllByStatus(PaymentScheduleStatus status);

    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate < :currentDate AND ps.status NOT IN (:excludedStatuses)")
    List<PaymentSchedule> findOverdueSchedules(@Param("currentDate") LocalDate currentDate,
                                               @Param("excludedStatuses") List<PaymentScheduleStatus> excludedStatuses);

    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate BETWEEN :startDate AND :endDate ORDER BY ps.paymentDate")
    List<PaymentSchedule> findByPeriod(@Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate);

    @Query("SELECT ps FROM PaymentSchedule ps WHERE ps.paymentDate <= :date AND ps.status = :status ORDER BY ps.paymentDate")
    List<PaymentSchedule> findPendingByDate(@Param("date") LocalDate date,
                                            @Param("status") PaymentScheduleStatus status);

    @Query("SELECT COUNT(ps) > 0 FROM PaymentSchedule ps WHERE ps.contract.id = :contractId AND ps.status NOT IN (:excludedStatuses)")
    boolean hasUnpaidSchedules(@Param("contractId") Long contractId,
                               @Param("excludedStatuses") List<PaymentScheduleStatus> excludedStatuses);

    void deleteByContractId(Long contractId);
}
