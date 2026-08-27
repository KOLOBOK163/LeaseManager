package com.LeaseManager.Service.Export;

import com.LeaseManager.Entity.*;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Сервис для экспорта данных в Excel
 */
@Service
public class ExcelExportService {

    private final ContractRepository contractRepository;
    private final PaymentScheduleRepository paymentScheduleRepository;

    public ExcelExportService(ContractRepository contractRepository,
                             PaymentScheduleRepository paymentScheduleRepository) {
        this.contractRepository = contractRepository;
        this.paymentScheduleRepository = paymentScheduleRepository;
    }

    /**
     * Экспорт договора с графиком платежей в Excel
     */
    public byte[] exportContract(Long contractId) throws IOException {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new IllegalArgumentException("Договор не найден"));

        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contractId);

        try (Workbook workbook = new XSSFWorkbook()) {
            // Лист с информацией о договоре
            Sheet contractSheet = workbook.createSheet("Договор");
            createContractSheet(contractSheet, contract);

            // Лист с графиком платежей
            Sheet scheduleSheet = workbook.createSheet("График платежей");
            createScheduleSheet(scheduleSheet, schedules);

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    /**
     * Экспорт всех договоров в Excel
     */
    public byte[] exportAllContracts() throws IOException {
        List<Contract> contracts = contractRepository.findAll();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Договоры");

            // Заголовки
            Row headerRow = sheet.createRow(0);
            CellStyle headerStyle = createHeaderStyle(workbook);

            String[] headers = {"№", "Номер договора", "Клиент", "Оборудование", "Дата начала",
                               "Дата окончания", "Сумма", "Ставка %", "Статус"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Данные
            int rowNum = 1;
            for (Contract contract : contracts) {
                Row row = sheet.createRow(rowNum++);

                row.createCell(0).setCellValue(rowNum - 1);
                row.createCell(1).setCellValue(contract.getContractNumber());
                row.createCell(2).setCellValue(getClientName(contract.getClient()));
                row.createCell(3).setCellValue(contract.getEquipment().getName());
                row.createCell(4).setCellValue(contract.getStartDate().toString());
                row.createCell(5).setCellValue(contract.getEndDate().toString());
                row.createCell(6).setCellValue(contract.getTotalAmount().doubleValue());
                row.createCell(7).setCellValue(contract.getInterestRate().doubleValue());
                row.createCell(8).setCellValue(contract.getStatus().toString());
            }

            // Автоширина колонок
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    /**
     * Создание листа с информацией о договоре
     */
    private void createContractSheet(Sheet sheet, Contract contract) {
        CellStyle labelStyle = createLabelStyle(sheet.getWorkbook());
        CellStyle valueStyle = createValueStyle(sheet.getWorkbook());

        int rowNum = 0;

        // Заголовок
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("ДОГОВОР ЛИЗИНГА № " + contract.getContractNumber());
        CellStyle titleStyle = createTitleStyle(sheet.getWorkbook());
        titleCell.setCellStyle(titleStyle);

        rowNum++; // Пустая строка

        // Информация о договоре
        addRow(sheet, rowNum++, "Номер договора:", contract.getContractNumber(), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Клиент:", getClientName(contract.getClient()), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "ИНН:", contract.getClient().getInn(), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Оборудование:", contract.getEquipment().getName(), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Дата начала:", contract.getStartDate().toString(), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Дата окончания:", contract.getEndDate().toString(), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Общая сумма:", String.format("%.2f руб.", contract.getTotalAmount()), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Процентная ставка:", String.format("%.2f%%", contract.getInterestRate()), labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Период платежей:", contract.getPaymentPeriodMonths() + " мес.", labelStyle, valueStyle);
        addRow(sheet, rowNum++, "Статус:", contract.getStatus().toString(), labelStyle, valueStyle);

        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 8000);
    }

    /**
     * Создание листа с графиком платежей
     */
    private void createScheduleSheet(Sheet sheet, List<PaymentSchedule> schedules) {
        CellStyle headerStyle = createHeaderStyle(sheet.getWorkbook());

        // Заголовки
        Row headerRow = sheet.createRow(0);
        String[] headers = {"Период", "Дата платежа", "Общая сумма", "Основной долг", "Проценты", "Статус"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // Данные
        int rowNum = 1;
        for (PaymentSchedule schedule : schedules) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(schedule.getPeriodNumber());
            row.createCell(1).setCellValue(schedule.getPaymentDate().toString());
            row.createCell(2).setCellValue(schedule.getTotalAmount().doubleValue());
            row.createCell(3).setCellValue(schedule.getPrincipalPart().doubleValue());
            row.createCell(4).setCellValue(schedule.getInterestPart().doubleValue());
            row.createCell(5).setCellValue(schedule.getStatus().toString());
        }

        // Автоширина колонок
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private void addRow(Sheet sheet, int rowNum, String label, String value, CellStyle labelStyle, CellStyle valueStyle) {
        Row row = sheet.createRow(rowNum);
        Cell labelCell = row.createCell(0);
        labelCell.setCellValue(label);
        labelCell.setCellStyle(labelStyle);

        Cell valueCell = row.createCell(1);
        valueCell.setCellValue(value);
        valueCell.setCellStyle(valueStyle);
    }

    private String getClientName(Client client) {
        String name = client.getFullName();
        if (name == null || name.isEmpty()) {
            name = client.getCompanyName();
        }
        return name;
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 12);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        style.setFont(font);
        return style;
    }

    private CellStyle createLabelStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    private CellStyle createValueStyle(Workbook workbook) {
        return workbook.createCellStyle();
    }
}
