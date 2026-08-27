package com.LeaseManager.Entity;

/**
 * Статусы оборудования
 */
public enum EquipmentStatus {
    AVAILABLE,      // Доступно
    LEASED,         // В лизинге
    MAINTENANCE,    // На обслуживании
    SOLD,           // Продано
    WRITE_OFF       // Списано
}
