package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Contract.InsuranceDto;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Repository.EquipmentRepository;
import com.LeaseManager.Service.Insurance.InsuranceService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * Контроллер для управления страхованием
 */
@RestController
@RequestMapping("/api/insurance")
public class InsuranceController {

    private final InsuranceService insuranceService;
    private final EquipmentRepository equipmentRepository;

    public InsuranceController(InsuranceService insuranceService, EquipmentRepository equipmentRepository) {
        this.insuranceService = insuranceService;
        this.equipmentRepository = equipmentRepository;
    }

    @PostMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<Contract> addInsurance(
            @PathVariable Long contractId,
            @Valid @RequestBody InsuranceDto insuranceDto) {
        Contract contract = insuranceService.addInsurance(contractId, insuranceDto);
        return ResponseEntity.ok(contract);
    }

    @PutMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<Contract> updateInsurance(
            @PathVariable Long contractId,
            @Valid @RequestBody InsuranceDto insuranceDto) {
        Contract contract = insuranceService.updateInsurance(contractId, insuranceDto);
        return ResponseEntity.ok(contract);
    }

    @GetMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<InsuranceDto> getInsurance(@PathVariable Long contractId) {
        InsuranceDto insurance = insuranceService.getInsurance(contractId);
        return ResponseEntity.ok(insurance);
    }

    @GetMapping("/calculate-premium/equipment/{equipmentId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> calculatePremium(@PathVariable Long equipmentId) {
        Equipment equipment = equipmentRepository.findById(equipmentId)
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено"));
        BigDecimal premium = insuranceService.calculateInsurancePremium(equipment);
        return ResponseEntity.ok(premium);
    }

    @GetMapping("/calculate-monthly-premium")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<BigDecimal> calculateMonthlyPremium(@RequestParam BigDecimal annualPremium) {
        BigDecimal monthlyPremium = insuranceService.calculateMonthlyPremium(annualPremium);
        return ResponseEntity.ok(monthlyPremium);
    }

    @GetMapping("/expiring")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<Contract>> getExpiringInsurance(@RequestParam(defaultValue = "30") int daysAhead) {
        List<Contract> contracts = insuranceService.getContractsWithExpiringInsurance(daysAhead);
        return ResponseEntity.ok(contracts);
    }

    @GetMapping("/expired")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<Contract>> getExpiredInsurance() {
        List<Contract> contracts = insuranceService.getContractsWithExpiredInsurance();
        return ResponseEntity.ok(contracts);
    }
}
