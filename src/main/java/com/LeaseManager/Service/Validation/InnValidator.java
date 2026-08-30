package com.LeaseManager.Service.Validation;

import org.springframework.stereotype.Component;

@Component
public class InnValidator {

    public boolean isValid(String inn) {
        if (inn == null || inn.isEmpty()) {
            return false;
        }

        inn = inn.trim().replaceAll("\\s+", "");

        if (!inn.matches("\\d+")) {
            return false;
        }

        if (inn.length() == 10) {
            return validateInn10(inn);
        } else if (inn.length() == 12) {
            return validateInn12(inn);
        }

        return false;
    }

    private boolean validateInn10(String inn) {
        int[] coefficients = {2, 4, 10, 3, 5, 9, 4, 6, 8};
        int checksum = 0;

        for (int i = 0; i < 9; i++) {
            checksum += Character.getNumericValue(inn.charAt(i)) * coefficients[i];
        }

        int controlDigit = (checksum % 11) % 10;
        return controlDigit == Character.getNumericValue(inn.charAt(9));
    }

    private boolean validateInn12(String inn) {
        // Проверка 11-й цифры
        int[] coefficients11 = {7, 2, 4, 10, 3, 5, 9, 4, 6, 8};
        int checksum11 = 0;

        for (int i = 0; i < 10; i++) {
            checksum11 += Character.getNumericValue(inn.charAt(i)) * coefficients11[i];
        }

        int controlDigit11 = (checksum11 % 11) % 10;
        if (controlDigit11 != Character.getNumericValue(inn.charAt(10))) {
            return false;
        }

        int[] coefficients12 = {3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8};
        int checksum12 = 0;

        for (int i = 0; i < 11; i++) {
            checksum12 += Character.getNumericValue(inn.charAt(i)) * coefficients12[i];
        }

        int controlDigit12 = (checksum12 % 11) % 10;
        return controlDigit12 == Character.getNumericValue(inn.charAt(11));
    }

    public String getErrorMessage(String inn) {
        if (inn == null || inn.isEmpty()) {
            return "ИНН не может быть пустым";
        }

        inn = inn.trim().replaceAll("\\s+", "");

        if (!inn.matches("\\d+")) {
            return "ИНН должен содержать только цифры";
        }

        if (inn.length() != 10 && inn.length() != 12) {
            return "ИНН должен содержать 10 цифр (для юридических лиц) или 12 цифр (для физических лиц)";
        }

        return "Неверная контрольная сумма ИНН";
    }
}
