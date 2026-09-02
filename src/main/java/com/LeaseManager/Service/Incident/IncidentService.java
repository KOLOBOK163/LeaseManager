package com.LeaseManager.Service.Incident;

import com.LeaseManager.Dto.Incident.CreateIncidentRequest;
import com.LeaseManager.Dto.Incident.IncidentResponse;
import com.LeaseManager.Dto.Incident.UpdateIncidentRequest;
import com.LeaseManager.Entity.*;
import com.LeaseManager.Repository.*;
import com.LeaseManager.Service.Audit.AuditService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class IncidentService {

    private final EquipmentIncidentRepository incidentRepository;
    private final EquipmentRepository equipmentRepository;
    private final ContractRepository contractRepository;
    private final UserRepository userRepository;
    private final AuditService auditService;

    public IncidentService(EquipmentIncidentRepository incidentRepository,
                          EquipmentRepository equipmentRepository,
                          ContractRepository contractRepository,
                          UserRepository userRepository,
                          AuditService auditService) {
        this.incidentRepository = incidentRepository;
        this.equipmentRepository = equipmentRepository;
        this.contractRepository = contractRepository;
        this.userRepository = userRepository;
        this.auditService = auditService;
    }

    @Transactional
    public IncidentResponse createIncident(CreateIncidentRequest request, Long userId) {
        Equipment equipment = equipmentRepository.findById(request.getEquipmentId())
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + request.getEquipmentId()));

        Contract contract = null;
        if (request.getContractId() != null) {
            contract = contractRepository.findById(request.getContractId())
                    .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + request.getContractId()));
        }

        User reporter = null;
        if (userId != null) {
            reporter = userRepository.findById(userId).orElse(null);
        }

        EquipmentIncident incident = EquipmentIncident.builder()
                .equipment(equipment)
                .contract(contract)
                .incidentType(request.getIncidentType())
                .incidentDate(request.getIncidentDate() != null ? request.getIncidentDate() : LocalDateTime.now())
                .description(request.getDescription())
                .responsibleParty(request.getResponsibleParty() != null ?
                    request.getResponsibleParty() : EquipmentIncident.ResponsibleParty.UNDER_INVESTIGATION)
                .estimatedCost(request.getEstimatedCost())
                .status(EquipmentIncident.IncidentStatus.REPORTED)
                .policeReportNumber(request.getPoliceReportNumber())
                .insuranceClaimNumber(request.getInsuranceClaimNumber())
                .reportedBy(reporter)
                .build();

        if (incident.isCritical()) {
            equipment.setStatus(EquipmentStatus.WRITE_OFF);
        } else {
            equipment.setStatus(EquipmentStatus.MAINTENANCE);
        }
        equipmentRepository.save(equipment);

        if (incident.isCritical() && contract != null && contract.getStatus() == Contract.ContractStatus.ACTIVE) {
            contract.setStatus(Contract.ContractStatus.SUSPENDED);
            contractRepository.save(contract);
        }

        EquipmentIncident saved = incidentRepository.save(incident);

        auditService.log(userId, AuditLog.AuditAction.CREATE, "EquipmentIncident", saved.getId(),
                "Создан инцидент: " + request.getIncidentType() + " для оборудования " + equipment.getName(), null);

        return mapToResponse(saved);
    }

    @Transactional
    public IncidentResponse updateIncident(Long incidentId, UpdateIncidentRequest request, Long userId) {
        EquipmentIncident incident = incidentRepository.findById(incidentId)
                .orElseThrow(() -> new EntityNotFoundException("Инцидент не найден с id: " + incidentId));

        if (request.getDescription() != null) {
            incident.setDescription(request.getDescription());
        }
        if (request.getResponsibleParty() != null) {
            incident.setResponsibleParty(request.getResponsibleParty());
        }
        if (request.getEstimatedCost() != null) {
            incident.setEstimatedCost(request.getEstimatedCost());
        }
        if (request.getActualCost() != null) {
            incident.setActualCost(request.getActualCost());
        }
        if (request.getStatus() != null) {
            EquipmentIncident.IncidentStatus oldStatus = incident.getStatus();
            incident.setStatus(request.getStatus());

            if (request.getStatus() == EquipmentIncident.IncidentStatus.RESOLVED ||
                request.getStatus() == EquipmentIncident.IncidentStatus.CLOSED) {

                incident.setResolvedDate(LocalDateTime.now());

                if (userId != null) {
                    User resolver = userRepository.findById(userId).orElse(null);
                    incident.setResolvedBy(resolver);
                }

                Equipment equipment = incident.getEquipment();
                if (incident.getContract() != null &&
                    incident.getContract().getStatus() == Contract.ContractStatus.ACTIVE) {
                    equipment.setStatus(EquipmentStatus.LEASED);

                    if (incident.getContract().getStatus() == Contract.ContractStatus.SUSPENDED) {
                        incident.getContract().setStatus(Contract.ContractStatus.ACTIVE);
                        contractRepository.save(incident.getContract());
                    }
                } else {
                    equipment.setStatus(EquipmentStatus.AVAILABLE);
                }
                equipmentRepository.save(equipment);
            }
        }
        if (request.getResolutionNotes() != null) {
            incident.setResolutionNotes(request.getResolutionNotes());
        }
        if (request.getPoliceReportNumber() != null) {
            incident.setPoliceReportNumber(request.getPoliceReportNumber());
        }
        if (request.getInsuranceClaimNumber() != null) {
            incident.setInsuranceClaimNumber(request.getInsuranceClaimNumber());
        }
        if (request.getCompensationAmount() != null) {
            incident.setCompensationAmount(request.getCompensationAmount());
        }

        EquipmentIncident updated = incidentRepository.save(incident);

        auditService.log(userId, AuditLog.AuditAction.UPDATE, "EquipmentIncident", updated.getId(),
                "Обновлён инцидент #" + incidentId, null);

        return mapToResponse(updated);
    }

    @Transactional(readOnly = true)
    public IncidentResponse getIncidentById(Long incidentId) {
        EquipmentIncident incident = incidentRepository.findById(incidentId)
                .orElseThrow(() -> new EntityNotFoundException("Инцидент не найден с id: " + incidentId));
        return mapToResponse(incident);
    }

    @Transactional(readOnly = true)
    public List<IncidentResponse> getAllIncidents() {
        return incidentRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<IncidentResponse> getIncidentsByEquipment(Long equipmentId) {
        return incidentRepository.findByEquipmentId(equipmentId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<IncidentResponse> getIncidentsByContract(Long contractId) {
        return incidentRepository.findByContractId(contractId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<IncidentResponse> getActiveIncidents() {
        return incidentRepository.findActiveIncidents().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<IncidentResponse> getIncidentsRequiringCompensation() {
        return incidentRepository.findIncidentsRequiringCompensation().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public BigDecimal calculateCompensation(Long incidentId) {
        EquipmentIncident incident = incidentRepository.findById(incidentId)
                .orElseThrow(() -> new EntityNotFoundException("Инцидент не найден с id: " + incidentId));

        if (incident.getContract() == null) {
            throw new IllegalStateException("Инцидент не связан с договором");
        }

        Contract contract = incident.getContract();
        Equipment equipment = incident.getEquipment();

        BigDecimal initialCost = equipment.getPrice();

        // Рассчитываем амортизацию
        int totalPeriods = contract.getPaymentPeriodMonths();
        long monthsPassed = java.time.temporal.ChronoUnit.MONTHS.between(
                contract.getStartDate(), LocalDateTime.now());

        BigDecimal amortization = initialCost
                .multiply(BigDecimal.valueOf(monthsPassed))
                .divide(BigDecimal.valueOf(totalPeriods), 2, BigDecimal.ROUND_HALF_UP);

        // Остаточная стоимость
        BigDecimal residualValue = initialCost.subtract(amortization);

        // Упущенная выгода (30% от оставшихся платежей)
        long remainingPeriods = totalPeriods - monthsPassed;
        BigDecimal monthlyPayment = contract.getTotalAmount()
                .divide(BigDecimal.valueOf(totalPeriods), 2, BigDecimal.ROUND_HALF_UP);
        BigDecimal remainingPayments = monthlyPayment.multiply(BigDecimal.valueOf(remainingPeriods));
        BigDecimal lostProfit = remainingPayments.multiply(BigDecimal.valueOf(0.3));

        // Штраф (10% от остаточной стоимости)
        BigDecimal penalty = residualValue.multiply(BigDecimal.valueOf(0.1));

        // Итоговая компенсация
        BigDecimal totalCompensation = residualValue.add(lostProfit).add(penalty);

        return totalCompensation.setScale(2, BigDecimal.ROUND_HALF_UP);
    }

    @Transactional
    public void deleteIncident(Long incidentId, Long userId) {
        if (!incidentRepository.existsById(incidentId)) {
            throw new EntityNotFoundException("Инцидент не найден с id: " + incidentId);
        }

        incidentRepository.deleteById(incidentId);

        auditService.log(userId, AuditLog.AuditAction.DELETE, "EquipmentIncident", incidentId,
                "Удалён инцидент #" + incidentId, null);
    }

    private IncidentResponse mapToResponse(EquipmentIncident incident) {
        return IncidentResponse.builder()
                .id(incident.getId())
                .equipmentId(incident.getEquipment().getId())
                .equipmentName(incident.getEquipment().getName())
                .contractId(incident.getContract() != null ? incident.getContract().getId() : null)
                .contractNumber(incident.getContract() != null ? incident.getContract().getContractNumber() : null)
                .incidentType(incident.getIncidentType())
                .incidentDate(incident.getIncidentDate())
                .description(incident.getDescription())
                .responsibleParty(incident.getResponsibleParty())
                .estimatedCost(incident.getEstimatedCost())
                .actualCost(incident.getActualCost())
                .status(incident.getStatus())
                .resolutionNotes(incident.getResolutionNotes())
                .resolvedDate(incident.getResolvedDate())
                .policeReportNumber(incident.getPoliceReportNumber())
                .insuranceClaimNumber(incident.getInsuranceClaimNumber())
                .compensationAmount(incident.getCompensationAmount())
                .reportedByUsername(incident.getReportedBy() != null ? incident.getReportedBy().getUsername() : null)
                .resolvedByUsername(incident.getResolvedBy() != null ? incident.getResolvedBy().getUsername() : null)
                .requiresCompensation(incident.requiresCompensation())
                .critical(incident.isCritical())
                .build();
    }
}
