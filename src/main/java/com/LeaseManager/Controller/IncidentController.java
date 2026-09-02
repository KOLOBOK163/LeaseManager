package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Incident.CreateIncidentRequest;
import com.LeaseManager.Dto.Incident.IncidentResponse;
import com.LeaseManager.Dto.Incident.UpdateIncidentRequest;
import com.LeaseManager.Service.Incident.IncidentService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/incidents")
public class IncidentController {

    private final IncidentService incidentService;

    public IncidentController(IncidentService incidentService) {
        this.incidentService = incidentService;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<IncidentResponse> createIncident(
            @Valid @RequestBody CreateIncidentRequest request,
            @RequestHeader(value = "X-User-Id", required = false) Long userId) {
        IncidentResponse response = incidentService.createIncident(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<IncidentResponse> getIncidentById(@PathVariable Long id) {
        IncidentResponse response = incidentService.getIncidentById(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<IncidentResponse>> getAllIncidents() {
        List<IncidentResponse> incidents = incidentService.getAllIncidents();
        return ResponseEntity.ok(incidents);
    }

    @GetMapping("/equipment/{equipmentId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<IncidentResponse>> getIncidentsByEquipment(@PathVariable Long equipmentId) {
        List<IncidentResponse> incidents = incidentService.getIncidentsByEquipment(equipmentId);
        return ResponseEntity.ok(incidents);
    }

    @GetMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<IncidentResponse>> getIncidentsByContract(@PathVariable Long contractId) {
        List<IncidentResponse> incidents = incidentService.getIncidentsByContract(contractId);
        return ResponseEntity.ok(incidents);
    }

    @GetMapping("/active")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<IncidentResponse>> getActiveIncidents() {
        List<IncidentResponse> incidents = incidentService.getActiveIncidents();
        return ResponseEntity.ok(incidents);
    }

    @GetMapping("/requiring-compensation")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<IncidentResponse>> getIncidentsRequiringCompensation() {
        List<IncidentResponse> incidents = incidentService.getIncidentsRequiringCompensation();
        return ResponseEntity.ok(incidents);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<IncidentResponse> updateIncident(
            @PathVariable Long id,
            @Valid @RequestBody UpdateIncidentRequest request,
            @RequestHeader(value = "X-User-Id", required = false) Long userId) {
        IncidentResponse response = incidentService.updateIncident(id, request, userId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}/calculate-compensation")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> calculateCompensation(@PathVariable Long id) {
        BigDecimal compensation = incidentService.calculateCompensation(id);
        return ResponseEntity.ok(compensation);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteIncident(
            @PathVariable Long id,
            @RequestHeader(value = "X-User-Id", required = false) Long userId) {
        incidentService.deleteIncident(id, userId);
        return ResponseEntity.noContent().build();
    }
}
