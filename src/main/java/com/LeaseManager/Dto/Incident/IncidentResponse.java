package com.LeaseManager.Dto.Incident;

import com.LeaseManager.Entity.EquipmentIncident;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class IncidentResponse {

    private Long id;
    private Long equipmentId;
    private String equipmentName;
    private Long contractId;
    private String contractNumber;
    private EquipmentIncident.IncidentType incidentType;
    private LocalDateTime incidentDate;
    private String description;
    private EquipmentIncident.ResponsibleParty responsibleParty;
    private BigDecimal estimatedCost;
    private BigDecimal actualCost;
    private EquipmentIncident.IncidentStatus status;
    private String resolutionNotes;
    private LocalDateTime resolvedDate;
    private String policeReportNumber;
    private String insuranceClaimNumber;
    private BigDecimal compensationAmount;
    private String reportedByUsername;
    private String resolvedByUsername;
    private boolean requiresCompensation;
    private boolean critical;
}
