package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "equipment")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Equipment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false, foreignKey = @ForeignKey(name = "fk_equipment_category"))
    private Category category;

    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "model", length = 100)
    private String model;

    @Column(name = "manufacturer", length = 100)
    private String manufacturer;

    @Column(name = "serial_number", length = 100)
    private String serialNumber;

    @Column(name = "year_of_manufacture")
    private Integer yearOfManufacture;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private EquipmentStatus status = EquipmentStatus.AVAILABLE;

    @Column(name = "description", length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "equipment_type", length = 50)
    private EquipmentType equipmentType;

    @Column(name = "dimensions", length = 50)
    private String dimensions;

    @Column(name = "weight", precision = 8, scale = 2)
    private BigDecimal weight;

    @Column(name = "power_consumption", precision = 8, scale = 3)
    private BigDecimal powerConsumption;

    @Column(name = "voltage")
    private Integer voltage;

    @Column(name = "min_temperature")
    private Integer minTemperature;

    @Column(name = "max_temperature")
    private Integer maxTemperature;

    @Column(name = "volume", precision = 8, scale = 2)
    private BigDecimal volume;

    @Column(name = "body_material", length = 100)
    private String bodyMaterial;

    @Column(name = "installation_address", length = 500)
    private String installationAddress;

    @Column(name = "installation_date")
    private java.time.LocalDate installationDate;

    @Column(name = "next_maintenance_date")
    private java.time.LocalDate nextMaintenanceDate;

    @Column(name = "warranty_months")
    private Integer warrantyMonths;

    @Column(name = "service_contract_number", length = 50)
    private String serviceContractNumber;

    @Column(name = "energy_class", length = 10)
    private String energyClass;

    @Column(name = "country_of_origin", length = 100)
    private String countryOfOrigin;

    @Column(name = "last_maintenance_date")
    private java.time.LocalDate lastMaintenanceDate;

    @Column(name = "maintenance_notes", length = 1000)
    private String maintenanceNotes;

    public enum EquipmentType {
        REFRIGERATOR,
        FREEZER,
        SHOWCASE,
        CASH_REGISTER,
        SCALE,
        SHELVING,
        COOLER,
        HEAT_DISPLAY,
        SLICER,
        PACKAGING_MACHINE,
        TERMINAL,
        SCANNER,
        OTHER
    }
}
