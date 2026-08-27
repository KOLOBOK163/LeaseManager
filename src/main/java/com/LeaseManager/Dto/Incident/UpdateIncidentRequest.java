package com.LeaseManager.Dto.Incident;

import com.LeaseManager.Entity.EquipmentIncident;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateIncidentRequest {

    private String description;

    private EquipmentIncident.ResponsibleParty responsibleParty;

    private BigDecimal estimatedCost;

    private BigDecimal actualCost;

    private EquipmentIncident.IncidentStatus status;

    private String resolutionNotes;

    private String policeReportNumber;

    private String insuranceClaimNumber;

    private BigDecimal compensationAmount;
}
