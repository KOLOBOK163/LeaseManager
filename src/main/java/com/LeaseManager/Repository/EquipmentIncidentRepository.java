package com.LeaseManager.Repository;

import com.LeaseManager.Entity.EquipmentIncident;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EquipmentIncidentRepository extends JpaRepository<EquipmentIncident, Long> {

    /**
     * Найти все инциденты по оборудованию
     */
    List<EquipmentIncident> findByEquipmentId(Long equipmentId);

    /**
     * Найти все инциденты по договору
     */
    List<EquipmentIncident> findByContractId(Long contractId);

    /**
     * Найти инциденты по статусу
     */
    List<EquipmentIncident> findByStatus(EquipmentIncident.IncidentStatus status);

    /**
     * Найти инциденты по типу
     */
    List<EquipmentIncident> findByIncidentType(EquipmentIncident.IncidentType incidentType);

    /**
     * Найти инциденты по ответственной стороне
     */
    List<EquipmentIncident> findByResponsibleParty(EquipmentIncident.ResponsibleParty responsibleParty);

    /**
     * Найти активные инциденты (не закрытые)
     */
    @Query("SELECT i FROM EquipmentIncident i WHERE i.status NOT IN ('RESOLVED', 'CLOSED', 'CANCELLED')")
    List<EquipmentIncident> findActiveIncidents();

    /**
     * Найти инциденты за период
     */
    @Query("SELECT i FROM EquipmentIncident i WHERE i.incidentDate BETWEEN :startDate AND :endDate")
    List<EquipmentIncident> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                            @Param("endDate") LocalDateTime endDate);

    /**
     * Найти инциденты, требующие компенсации
     */
    @Query("SELECT i FROM EquipmentIncident i WHERE i.responsibleParty = 'LESSEE' AND i.status NOT IN ('RESOLVED', 'CLOSED')")
    List<EquipmentIncident> findIncidentsRequiringCompensation();

    /**
     * Подсчитать количество инцидентов по оборудованию
     */
    long countByEquipmentId(Long equipmentId);

    /**
     * Подсчитать количество инцидентов по договору
     */
    long countByContractId(Long contractId);
}
