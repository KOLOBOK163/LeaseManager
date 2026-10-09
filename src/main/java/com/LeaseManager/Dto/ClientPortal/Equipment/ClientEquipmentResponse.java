package com.LeaseManager.Dto.ClientPortal.Equipment;

import com.LeaseManager.Entity.EquipmentStatus;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ClientEquipmentResponse {
    private Long id;

    private String name;

    private Long categoryId;

    private String categoryName;

    private String model;

    private String manufacturer;

    private String serialNumber;

    private Integer yearOfManufacture;

    private String description;

    private String status;

    private String equipmentType;

    // Размеры оборудования (ШхГхВ)
    private String dimensions;

    private BigDecimal weight;

    private BigDecimal powerConsumption;

    private Integer voltage;

    private Integer minTemperature;

    private Integer maxTemperature;

    private BigDecimal volume;

    private String BodyMaterial;

    private String energyClass;

    private String countryOfOrigin;

    private LocalDate lastMaintenanceDate;

    private LocalDate nextMaintenanceDate;

    private Integer warrantyMonths;

    private String serviceContractNumber;

    private String maintenanceNotes;

    private Long contractId;

    private String contractNumber;

    private LocalDate contractStartDate;

    private LocalDate contractEndDate;

}
