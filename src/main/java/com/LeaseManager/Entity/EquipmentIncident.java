package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "equipment_incidents")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class EquipmentIncident {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "equipment_id", nullable = false, foreignKey = @ForeignKey(name = "fk_incident_equipment"))
    private Equipment equipment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contract_id", foreignKey = @ForeignKey(name = "fk_incident_contract"))
    private Contract contract;

    @Enumerated(EnumType.STRING)
    @Column(name = "incident_type", nullable = false, length = 30)
    private IncidentType incidentType;

    @Column(name = "incident_date", nullable = false)
    @Builder.Default
    private LocalDateTime incidentDate = LocalDateTime.now();

    @Column(name = "description", length = 2000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "responsible_party", length = 30)
    private ResponsibleParty responsibleParty;

    @Column(name = "estimated_cost", precision = 15, scale = 2)
    private BigDecimal estimatedCost;

    @Column(name = "actual_cost", precision = 15, scale = 2)
    private BigDecimal actualCost;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    @Builder.Default
    private IncidentStatus status = IncidentStatus.REPORTED;

    @Column(name = "resolution_notes", length = 2000)
    private String resolutionNotes;

    @Column(name = "resolved_date")
    private LocalDateTime resolvedDate;

    @Column(name = "police_report_number", length = 100)
    private String policeReportNumber;

    @Column(name = "insurance_claim_number", length = 100)
    private String insuranceClaimNumber;

    @Column(name = "compensation_amount", precision = 15, scale = 2)
    private BigDecimal compensationAmount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reported_by", foreignKey = @ForeignKey(name = "fk_incident_reporter"))
    private User reportedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "resolved_by", foreignKey = @ForeignKey(name = "fk_incident_resolver"))
    private User resolvedBy;

    public enum IncidentType {
        BREAKDOWN,
        DAMAGE,
        THEFT,
        FORCE_MAJEURE,
        LOSS
    }

    public enum ResponsibleParty {
        LESSOR,
        LESSEE,
        INSURANCE,
        FORCE_MAJEURE,
        UNDER_INVESTIGATION
    }

    public enum IncidentStatus {
        REPORTED,
        UNDER_INVESTIGATION,
        REPAIR_SCHEDULED,
        IN_REPAIR,
        RESOLVED,
        CLOSED,
        CANCELLED
    }

    public boolean requiresCompensation() {
        return responsibleParty == ResponsibleParty.LESSEE;
    }

    public boolean isCritical() {
        return incidentType == IncidentType.THEFT ||
               incidentType == IncidentType.LOSS ||
               incidentType == IncidentType.FORCE_MAJEURE;
    }
}
