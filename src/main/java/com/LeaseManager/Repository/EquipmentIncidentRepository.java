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

    List<EquipmentIncident> findByEquipmentId(Long equipmentId);

    List<EquipmentIncident> findByContractId(Long contractId);

    List<EquipmentIncident> findByStatus(EquipmentIncident.IncidentStatus status);

    List<EquipmentIncident> findByIncidentType(EquipmentIncident.IncidentType incidentType);

    List<EquipmentIncident> findByResponsibleParty(EquipmentIncident.ResponsibleParty responsibleParty);

    @Query("SELECT i FROM EquipmentIncident i WHERE i.status NOT IN ('RESOLVED', 'CLOSED', 'CANCELLED')")
    List<EquipmentIncident> findActiveIncidents();

    @Query("SELECT i FROM EquipmentIncident i WHERE i.incidentDate BETWEEN :startDate AND :endDate")
    List<EquipmentIncident> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT i FROM EquipmentIncident i WHERE i.responsibleParty = 'LESSEE' AND i.status NOT IN ('RESOLVED', 'CLOSED')")
    List<EquipmentIncident> findIncidentsRequiringCompensation();

    long countByEquipmentId(Long equipmentId);

    long countByContractId(Long contractId);
}
