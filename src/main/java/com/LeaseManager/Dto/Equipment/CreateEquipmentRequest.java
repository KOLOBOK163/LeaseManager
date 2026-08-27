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

    // === Характеристики торгового оборудования ===

    /**
     * Тип торгового оборудования
     */
    private String equipmentType;

    /**
     * Габариты (Д×Ш×В в см)
     */
    private String dimensions;

    /**
     * Вес в кг
     */
    private BigDecimal weight;

    /**
     * Потребляемая мощность в кВт
     */
    private BigDecimal powerConsumption;

    /**
     * Напряжение питания (В)
     */
    private Integer voltage;

    /**
     * Температурный режим (мин. температура в °C)
     */
    private Integer minTemperature;

    /**
     * Температурный режим (макс. температура в °C)
     */
    private Integer maxTemperature;

    /**
     * Полезный объём в литрах (для холодильников, витрин)
     */
    private BigDecimal volume;

    /**
     * Материал корпуса
     */
    private String bodyMaterial;

    /**
     * Адрес установки оборудования
     */
    private String installationAddress;

    /**
     * Дата установки
     */
    private java.time.LocalDate installationDate;

    /**
     * Дата следующего ТО
     */
    private java.time.LocalDate nextMaintenanceDate;

    /**
     * Гарантийный срок (месяцев)
     */
    private Integer warrantyMonths;

    /**
     * Сервисный контракт (номер договора на обслуживание)
     */
    private String serviceContractNumber;

    /**
     * Энергетический класс (A++, A+, A, B, C и т.д.)
     */
    private String energyClass;

    /**
     * Страна производства
     */
    private String countryOfOrigin;

    /**
     * Дата последнего ТО
     */
    private java.time.LocalDate lastMaintenanceDate;

    /**
     * Примечание по обслуживанию
     */
    private String maintenanceNotes;
}
