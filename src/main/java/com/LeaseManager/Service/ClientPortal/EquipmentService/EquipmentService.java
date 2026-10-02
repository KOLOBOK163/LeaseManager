package com.LeaseManager.Service.ClientPortal.EquipmentService;

import com.LeaseManager.Dto.Equipment.EquipmentResponse;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Repository.ContractRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clientPortalEquipmentService")
public class EquipmentService {

    private final ContractRepository contractRepository;

    public EquipmentService(ContractRepository contractRepository) {
        this.contractRepository = contractRepository;
    }

    public List<EquipmentResponse> getAllEquipment(Long clientId)
    {
        return contractRepository.findContractByClientIdWithEquipment(clientId)
                .stream()
                .map(contract -> toResponse(contract.getEquipment()))
                .distinct()
                .toList();
    }

    private EquipmentResponse toResponse(Equipment e)
    {
        return EquipmentResponse.builder()
                .id(e.getId())
                .name(e.getName())
                .categoryId(e.getCategory().getId())
                .categoryName(e.getCategory().getName())
                .price(e.getPrice())
                .model(e.getModel())
                .manufacturer(e.getManufacturer())
                .serialNumber(e.getSerialNumber())
                .yearOfManufacture(e.getYearOfManufacture())
                .status(e.getStatus().name())
                .description(e.getDescription())
                .equipmentType(e.getEquipmentType().name())
                .dimensions(e.getDimensions())
                .weight(e.getWeight())
                .powerConsumption(e.getPowerConsumption())
                .voltage(e.getVoltage())
                .minTemperature(e.getMinTemperature())
                .maxTemperature(e.getMaxTemperature())
                .volume(e.getVolume())
                .bodyMaterial(e.getBodyMaterial())
                .installationAddress(e.getInstallationAddress())
                .installationDate(e.getInstallationDate())
                .nextMaintenanceDate(e.getNextMaintenanceDate())
                .warrantyMonths(e.getWarrantyMonths())
                .serviceContractNumber(e.getServiceContractNumber())
                .energyClass(e.getEnergyClass())
                .countryOfOrigin(e.getCountryOfOrigin())
                .lastMaintenanceDate(e.getLastMaintenanceDate())
                .maintenanceNotes(e.getMaintenanceNotes())
                .build();
    }

}
