package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Торговое оборудование для лизинга
 */
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

    // === Характеристики торгового оборудования ===

    /**
     * Тип торгового оборудования
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "equipment_type", length = 50)
    private EquipmentType equipmentType;

    /**
     * Габариты (Д×Ш×В в см)
     */
    @Column(name = "dimensions", length = 50)
    private String dimensions;

    /**
     * Вес в кг
     */
    @Column(name = "weight", precision = 8, scale = 2)
    private BigDecimal weight;

    /**
     * Потребляемая мощность в кВт
     */
    @Column(name = "power_consumption", precision = 8, scale = 3)
    private BigDecimal powerConsumption;

    /**
     * Напряжение питания (В)
     */
    @Column(name = "voltage")
    private Integer voltage;

    /**
     * Температурный режим (мин. температура в °C)
     */
    @Column(name = "min_temperature")
    private Integer minTemperature;

    /**
     * Температурный режим (макс. температура в °C)
     */
    @Column(name = "max_temperature")
    private Integer maxTemperature;

    /**
     * Полезный объём в литрах (для холодильников, витрин)
     */
    @Column(name = "volume", precision = 8, scale = 2)
    private BigDecimal volume;

    /**
     * Материал корпуса
     */
    @Column(name = "body_material", length = 100)
    private String bodyMaterial;

    /**
     * Адрес установки оборудования
     */
    @Column(name = "installation_address", length = 500)
    private String installationAddress;

    /**
     * Дата установки
     */
    @Column(name = "installation_date")
    private java.time.LocalDate installationDate;

    /**
     * Дата следующего ТО
     */
    @Column(name = "next_maintenance_date")
    private java.time.LocalDate nextMaintenanceDate;

    /**
     * Гарантийный срок (месяцев)
     */
    @Column(name = "warranty_months")
    private Integer warrantyMonths;

    /**
     * Сервисный контракт (номер договора на обслуживание)
     */
    @Column(name = "service_contract_number", length = 50)
    private String serviceContractNumber;

    /**
     * Энергетический класс (A++, A+, A, B, C и т.д.)
     */
    @Column(name = "energy_class", length = 10)
    private String energyClass;

    /**
     * Страна производства
     */
    @Column(name = "country_of_origin", length = 100)
    private String countryOfOrigin;

    /**
     * Дата последнего ТО
     */
    @Column(name = "last_maintenance_date")
    private java.time.LocalDate lastMaintenanceDate;

    /**
     * Примечание по обслуживанию
     */
    @Column(name = "maintenance_notes", length = 1000)
    private String maintenanceNotes;

    /**
     * Типы торгового оборудования
     */
    public enum EquipmentType {
        REFRIGERATOR,       // Холодильник
        FREEZER,            // Морозильник
        SHOWCASE,           // Витрина
        CASH_REGISTER,      // Кассовый аппарат
        SCALE,              // Весы
        SHELVING,           // Стеллажи
        COOLER,             // Охладитель
        HEAT_DISPLAY,       // Тепловая витрина
        SLICER,             // Слайсер
        PACKAGING_MACHINE,  // Упаковочная машина
        TERMINAL,           // Платёжный терминал
        SCANNER,            // Сканер штрих-кодов
        OTHER               // Другое
    }
}
