package com.LeaseManager.Entity;

/**
 * Статусы графика платежей
 */
public enum PaymentScheduleStatus {
    /**
     * Ожидает оплаты
     */
    PENDING,

    /**
     * Полностью оплачен
     */
    PAID,

    /**
     * Просрочен
     */
    OVERDUE,

    /**
     * Частично оплачен
     */
    PARTIAL,

    /**
     * Отменен
     */
    CANCELLED
}
