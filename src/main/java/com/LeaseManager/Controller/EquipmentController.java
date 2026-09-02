package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Equipment.CreateEquipmentRequest;
import com.LeaseManager.Dto.Equipment.EquipmentResponse;
import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Service.Audit.AuditService;
import com.LeaseManager.Service.Equipment.EquipmentService;
import com.LeaseManager.Util.AuditUtil;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/equipment")
public class EquipmentController {

    private final EquipmentService equipmentService;
    private final AuditService auditService;

    public EquipmentController(EquipmentService equipmentService, AuditService auditService) {
        this.equipmentService = equipmentService;
        this.auditService = auditService;
    }

    @GetMapping
    public ResponseEntity<List<EquipmentResponse>> getAllEquipment(
            @RequestParam(required = false) String status) {
        return ResponseEntity.ok(equipmentService.getAllEquipment(status));
    }

    @GetMapping("/{id}")
    public ResponseEntity<EquipmentResponse> getEquipmentById(@PathVariable Long id) {
        EquipmentResponse equipment = equipmentService.getEquipmentById(id);
        return ResponseEntity.ok(equipment);
    }

    @PostMapping
    public ResponseEntity<EquipmentResponse> createEquipment(@Valid @RequestBody CreateEquipmentRequest request) {
        EquipmentResponse created = equipmentService.createEquipment(request);
        auditService.log(
            AuditUtil.getCurrentUserId(),
            AuditLog.AuditAction.CREATE,
            "Equipment",
            created.getId(),
            "Создано оборудование: " + created.getName(),
            AuditUtil.getClientIp()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EquipmentResponse> updateEquipment(@PathVariable Long id, @Valid @RequestBody CreateEquipmentRequest request) {
        EquipmentResponse updated = equipmentService.updateEquipment(id, request);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.UPDATE,
                "Equipment",
                id,
                "Обновлено оборудование: " + updated.getName(),
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEquipment(@PathVariable Long id) {
        EquipmentResponse equipment = equipmentService.getEquipmentById(id);
        equipmentService.delete(id);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.DELETE,
                "Equipment",
                id,
                "Удалено оборудование: " + equipment.getName(),
                AuditUtil.getClientIp()
        );
        return ResponseEntity.noContent().build();
    }
}
