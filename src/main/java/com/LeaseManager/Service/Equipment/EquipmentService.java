package com.LeaseManager.Service.Equipment;

import com.LeaseManager.Dto.Equipment.CreateEquipmentRequest;
import com.LeaseManager.Dto.Equipment.EquipmentResponse;
import com.LeaseManager.Entity.Category;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.EquipmentStatus;
import com.LeaseManager.Repository.CategoryRepository;
import com.LeaseManager.Repository.EquipmentRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class EquipmentService {

    private final EquipmentRepository equipmentRepository;
    private final CategoryRepository categoryRepository;

    public EquipmentService(EquipmentRepository equipmentRepository,
                            CategoryRepository categoryRepository) {
        this.equipmentRepository = equipmentRepository;
        this.categoryRepository = categoryRepository;
    }

    @Transactional(readOnly = true)
    public List<EquipmentResponse> getAllEquipment(String status) {
        List<Equipment> equipmentList;
        if (status != null && !status.isBlank()) {
            try {
                EquipmentStatus equipmentStatus = EquipmentStatus.valueOf(status.toUpperCase());
                equipmentList = equipmentRepository.findByStatus(equipmentStatus);
            } catch (IllegalArgumentException e) {
                equipmentList = equipmentRepository.findAll();
            }
        } else {
            equipmentList = equipmentRepository.findAll();
        }
        return equipmentList.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public EquipmentResponse getEquipmentById(Long id) {
        return equipmentRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + id));
    }

    @Transactional
    public EquipmentResponse createEquipment(CreateEquipmentRequest request) {
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new EntityNotFoundException("Категория не найдена с id: " + request.getCategoryId()));

        Equipment.EquipmentType equipmentType = null;
        if (request.getEquipmentType() != null && !request.getEquipmentType().isBlank()) {
            try {
                equipmentType = Equipment.EquipmentType.valueOf(request.getEquipmentType().toUpperCase());
            } catch (IllegalArgumentException e) {
            }
        }

        Equipment equipment = Equipment.builder()
                .name(request.getName())
                .category(category)
                .price(BigDecimal.valueOf(request.getPrice()))
                .model(request.getModel())
                .manufacturer(request.getManufacturer())
                .serialNumber(request.getSerialNumber())
                .yearOfManufacture(request.getYearOfManufacture())
                .description(request.getDescription())
                .equipmentType(equipmentType)
                .dimensions(request.getDimensions())
                .weight(request.getWeight())
                .powerConsumption(request.getPowerConsumption())
                .voltage(request.getVoltage())
                .minTemperature(request.getMinTemperature())
                .maxTemperature(request.getMaxTemperature())
                .volume(request.getVolume())
                .bodyMaterial(request.getBodyMaterial())
                .installationAddress(request.getInstallationAddress())
                .installationDate(request.getInstallationDate())
                .nextMaintenanceDate(request.getNextMaintenanceDate())
                .warrantyMonths(request.getWarrantyMonths())
                .serviceContractNumber(request.getServiceContractNumber())
                .energyClass(request.getEnergyClass())
                .countryOfOrigin(request.getCountryOfOrigin())
                .lastMaintenanceDate(request.getLastMaintenanceDate())
                .maintenanceNotes(request.getMaintenanceNotes())
                .build();

        if (request.getStatus() != null && !request.getStatus().isBlank()) {
            try {
                equipment.setStatus(EquipmentStatus.valueOf(request.getStatus().toUpperCase()));
            } catch (IllegalArgumentException e) {
                equipment.setStatus(EquipmentStatus.AVAILABLE);
            }
        }

        Equipment saved = equipmentRepository.save(equipment);
        return toResponse(saved);
    }

    @Transactional
    public EquipmentResponse updateEquipment(Long id, CreateEquipmentRequest request) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + id));

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new EntityNotFoundException("Категория не найдена с id: " + request.getCategoryId()));

        equipment.setName(request.getName());
        equipment.setCategory(category);
        equipment.setPrice(BigDecimal.valueOf(request.getPrice()));
        equipment.setModel(request.getModel());
        equipment.setManufacturer(request.getManufacturer());
        equipment.setSerialNumber(request.getSerialNumber());
        equipment.setYearOfManufacture(request.getYearOfManufacture());
        equipment.setDescription(request.getDescription());

        if (request.getEquipmentType() != null && !request.getEquipmentType().isBlank()) {
            try {
                equipment.setEquipmentType(Equipment.EquipmentType.valueOf(request.getEquipmentType().toUpperCase()));
            } catch (IllegalArgumentException e) {
            }
        }
        equipment.setDimensions(request.getDimensions());
        equipment.setWeight(request.getWeight());
        equipment.setPowerConsumption(request.getPowerConsumption());
        equipment.setVoltage(request.getVoltage());
        equipment.setMinTemperature(request.getMinTemperature());
        equipment.setMaxTemperature(request.getMaxTemperature());
        equipment.setVolume(request.getVolume());
        equipment.setBodyMaterial(request.getBodyMaterial());
        equipment.setInstallationAddress(request.getInstallationAddress());
        equipment.setInstallationDate(request.getInstallationDate());
        equipment.setNextMaintenanceDate(request.getNextMaintenanceDate());
        equipment.setWarrantyMonths(request.getWarrantyMonths());
        equipment.setServiceContractNumber(request.getServiceContractNumber());
        equipment.setEnergyClass(request.getEnergyClass());
        equipment.setCountryOfOrigin(request.getCountryOfOrigin());
        equipment.setLastMaintenanceDate(request.getLastMaintenanceDate());
        equipment.setMaintenanceNotes(request.getMaintenanceNotes());

        if (request.getStatus() != null && !request.getStatus().isBlank()) {
            try {
                equipment.setStatus(EquipmentStatus.valueOf(request.getStatus().toUpperCase()));
            } catch (IllegalArgumentException e) {
            }
        }

        Equipment saved = equipmentRepository.save(equipment);
        return toResponse(saved);
    }

    @Transactional
    public void delete(Long id) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + id));

        if (equipment.getStatus() != EquipmentStatus.AVAILABLE) {
            throw new IllegalStateException("Можно удалить только оборудование со статусом 'Доступно'");
        }

        equipmentRepository.deleteById(id);
    }

    private EquipmentResponse toResponse(Equipment equipment) {
        return EquipmentResponse.builder()
                .id(equipment.getId())
                .name(equipment.getName())
                .categoryId(equipment.getCategory().getId())
                .categoryName(equipment.getCategory().getName())
                .price(equipment.getPrice())
                .model(equipment.getModel())
                .manufacturer(equipment.getManufacturer())
                .serialNumber(equipment.getSerialNumber())
                .yearOfManufacture(equipment.getYearOfManufacture())
                .status(equipment.getStatus().name())
                .description(equipment.getDescription())
                .equipmentType(equipment.getEquipmentType() != null ? equipment.getEquipmentType().name() : null)
                .dimensions(equipment.getDimensions())
                .weight(equipment.getWeight())
                .powerConsumption(equipment.getPowerConsumption())
                .voltage(equipment.getVoltage())
                .minTemperature(equipment.getMinTemperature())
                .maxTemperature(equipment.getMaxTemperature())
                .volume(equipment.getVolume())
                .bodyMaterial(equipment.getBodyMaterial())
                .installationAddress(equipment.getInstallationAddress())
                .installationDate(equipment.getInstallationDate())
                .nextMaintenanceDate(equipment.getNextMaintenanceDate())
                .warrantyMonths(equipment.getWarrantyMonths())
                .serviceContractNumber(equipment.getServiceContractNumber())
                .energyClass(equipment.getEnergyClass())
                .countryOfOrigin(equipment.getCountryOfOrigin())
                .lastMaintenanceDate(equipment.getLastMaintenanceDate())
                .maintenanceNotes(equipment.getMaintenanceNotes())
                .build();
    }
}
