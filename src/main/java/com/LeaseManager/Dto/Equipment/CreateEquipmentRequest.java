package com.LeaseManager.Dto.Equipment;

import com.LeaseManager.Entity.Equipment;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateEquipmentRequest {

    @NotBlank(message = "Название обязательно")
    private String name;

    @NotNull(message = "Категория обязательна")
    private Long categoryId;

    @NotNull(message = "Цена обязательна")
    @DecimalMin(value = "0.01", message = "Цена должна быть больше 0")
    private Double price;

    private String model;

    private String manufacturer;

    private String serialNumber;

    private Integer yearOfManufacture;

    private String status;

    private String description;

    private String equipmentType;

    private String dimensions;

    private BigDecimal weight;

    private BigDecimal powerConsumption;

    private Integer voltage;

    private Integer minTemperature;

    private Integer maxTemperature;

    private BigDecimal volume;

    private String bodyMaterial;

    private String installationAddress;

    private java.time.LocalDate installationDate;

    private java.time.LocalDate nextMaintenanceDate;

    private Integer warrantyMonths;

    private String serviceContractNumber;

    private String energyClass;

    private String countryOfOrigin;

    private java.time.LocalDate lastMaintenanceDate;

    private String maintenanceNotes;
}
