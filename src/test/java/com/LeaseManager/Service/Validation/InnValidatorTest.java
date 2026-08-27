package com.LeaseManager.Service.Validation;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Тесты для валидатора ИНН
 */
class InnValidatorTest {

    private final InnValidator validator = new InnValidator();

    @Test
    void testValidInn10() {
        // Валидный ИНН юридического лица (10 цифр)
        assertTrue(validator.isValid("7707083893"));
    }

    @Test
    void testValidInn12() {
        // Валидный ИНН физического лица (12 цифр)
        assertTrue(validator.isValid("500100732259"));
    }

    @Test
    void testInvalidInn10() {
        // Невалидный ИНН (неверная контрольная сумма)
        assertFalse(validator.isValid("7707083894"));
    }

    @Test
    void testInvalidInn12() {
        // Невалидный ИНН (неверная контрольная сумма)
        assertFalse(validator.isValid("500100732250"));
    }

    @Test
    void testInvalidLength() {
        // Неверная длина
        assertFalse(validator.isValid("123456789"));
        assertFalse(validator.isValid("12345678901"));
    }

    @Test
    void testNullOrEmpty() {
        assertFalse(validator.isValid(null));
        assertFalse(validator.isValid(""));
        assertFalse(validator.isValid("   "));
    }

    @Test
    void testNonNumeric() {
        assertFalse(validator.isValid("123456789A"));
        assertFalse(validator.isValid("abc1234567"));
    }

    @Test
    void testErrorMessage() {
        String message = validator.getErrorMessage("123");
        assertNotNull(message);
        assertTrue(message.contains("10") || message.contains("12"));
    }
}
