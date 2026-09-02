package com.LeaseManager.Service.Validation;

import org.springframework.stereotype.Component;

@Component
public class BankAccountValidator {

    public boolean isValidAccount(String accountNumber, String bik) {
        if (accountNumber == null || bik == null) {
            return false;
        }

        accountNumber = accountNumber.trim().replaceAll("\\s+", "");
        bik = bik.trim().replaceAll("\\s+", "");

        // Проверяем формат
        if (!accountNumber.matches("\\d{20}")) {
            return false;
        }

        if (!bik.matches("\\d{9}")) {
            return false;
        }

        String bikAccountNumber = bik.substring(6) + accountNumber;
        return checkControlSum(bikAccountNumber);
    }

    public boolean isValidBik(String bik) {
        if (bik == null) {
            return false;
        }

        bik = bik.trim().replaceAll("\\s+", "");
        return bik.matches("\\d{9}");
    }

    private boolean checkControlSum(String bikAccountNumber) {
        // Берём последние 3 цифры БИК + 20 цифр счёта = 23 цифры
        if (bikAccountNumber.length() != 23) {
            return false;
        }

        int[] coefficients = {7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1};
        int sum = 0;

        for (int i = 0; i < 23; i++) {
            sum += Character.getNumericValue(bikAccountNumber.charAt(i)) * coefficients[i];
        }

        return sum % 10 == 0;
    }

    public String getAccountErrorMessage(String accountNumber) {
        if (accountNumber == null || accountNumber.isEmpty()) {
            return "Расчётный счёт не может быть пустым";
        }

        accountNumber = accountNumber.trim().replaceAll("\\s+", "");

        if (!accountNumber.matches("\\d+")) {
            return "Расчётный счёт должен содержать только цифры";
        }

        if (accountNumber.length() != 20) {
            return "Расчётный счёт должен содержать 20 цифр";
        }

        return "Неверная контрольная сумма расчётного счёта";
    }

    public String getBikErrorMessage(String bik) {
        if (bik == null || bik.isEmpty()) {
            return "БИК не может быть пустым";
        }

        bik = bik.trim().replaceAll("\\s+", "");

        if (!bik.matches("\\d+")) {
            return "БИК должен содержать только цифры";
        }

        if (bik.length() != 9) {
            return "БИК должен содержать 9 цифр";
        }

        return "Неверный формат БИК";
    }
}
