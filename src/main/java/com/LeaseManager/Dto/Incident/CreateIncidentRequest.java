package com.LeaseManager.Dto.Incident;

import com.LeaseManager.Entity.EquipmentIncident;
import jakarta.validation.constraints.NotNull;
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
public class CreateIncidentRequest {

    @NotNull(message = "ID оборудования обязателен")
    private Long equipmentId;

    private Long contractId;

    @NotNull(message = "Тип инцидента обязателен")
    private EquipmentIncident.IncidentType incidentType;

    private LocalDateTime incidentDate;

    @NotNull(message = "Описание инцидента обязательно")
    private String description;

    private EquipmentIncident.ResponsibleParty responsibleParty;

    private BigDecimal estimatedCost;

    private String policeReportNumber;

    private String insuranceClaimNumber;
}
