package com.LeaseManager.Service;

import com.LeaseManager.Dto.Contract.ChangeContractStatusRequest;
import com.LeaseManager.Dto.Contract.ContractStatisticsDto;
import com.LeaseManager.Dto.Contract.CreateContractRequest;
import com.LeaseManager.Dto.Contract.GeneratePaymentScheduleRequest;
import com.LeaseManager.Dto.Contract.UpdateContractRequest;
import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.EquipmentStatus;
import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Repository.ClientRepository;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.EquipmentRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class ContractService {

    private final ContractRepository contractRepository;
    private final ClientRepository clientRepository;
    private final EquipmentRepository equipmentRepository;
    private final PaymentScheduleRepository paymentScheduleRepository;

    public ContractService(ContractRepository contractRepository,
                           ClientRepository clientRepository,
                           EquipmentRepository equipmentRepository,
                           PaymentScheduleRepository paymentScheduleRepository) {
        this.contractRepository = contractRepository;
        this.clientRepository = clientRepository;
        this.equipmentRepository = equipmentRepository;
        this.paymentScheduleRepository = paymentScheduleRepository;
    }

    @Transactional(readOnly = true)
    public List<Contract> getAllContracts(String status, String search) {
        // Если есть поисковый запрос, используем поиск
        if (search != null && !search.isBlank()) {
            return contractRepository.searchContracts(search);
        }

        // Иначе фильтруем по статусу или возвращаем все
        if (status != null && !status.isBlank()) {
            try {
                Contract.ContractStatus contractStatus = Contract.ContractStatus.valueOf(status.toUpperCase());
                return contractRepository.findByStatus(contractStatus);
            } catch (IllegalArgumentException e) {
                return contractRepository.findAll();
            }
        }
        return contractRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Contract getContractById(Long contractId) {
        return contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));
    }

    @Transactional
    public Contract createContract(CreateContractRequest request) {
        Client client = clientRepository.findById(request.getClientId())
                .orElseThrow(() -> new EntityNotFoundException("Клиент не найден с id: " + request.getClientId()));

        Equipment equipment = equipmentRepository.findById(request.getEquipmentId())
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + request.getEquipmentId()));

        // Проверка доступности оборудования
        if (equipment.getStatus() != EquipmentStatus.AVAILABLE) {
            throw new IllegalStateException("Оборудование недоступно для лизинга. Текущий статус: " + equipment.getStatus());
        }

        // Автоматическая генерация номера договора, если не указан
        String contractNumber = request.getContractNumber();
        if (contractNumber == null || contractNumber.isBlank()) {
            contractNumber = generateContractNumber();
        }

        Contract contract = Contract.builder()
                .contractNumber(contractNumber)
                .client(client)
                .equipment(equipment)
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .totalAmount(request.getTotalAmount())
                .interestRate(request.getInterestRate())
                .paymentPeriodMonths(request.getPeriodMonths())
                .status(Contract.ContractStatus.DRAFT)
                .description(request.getDescription())
                .build();

        return contractRepository.save(contract);
    }

    /**
     * Генерация номера договора в формате ЛД-20xx-0xx
     */
    private String generateContractNumber() {
        int currentYear = LocalDate.now().getYear();
        String pattern = "ЛД-" + currentYear + "-%";

        List<Contract> existingContracts = contractRepository.findByContractNumberPattern(pattern);

        int nextNumber = 1;
        if (!existingContracts.isEmpty()) {
            String lastContractNumber = existingContracts.get(0).getContractNumber();
            // Извлекаем последний номер из формата ЛД-2026-001
            String[] parts = lastContractNumber.split("-");
            if (parts.length == 3) {
                try {
                    nextNumber = Integer.parseInt(parts[2]) + 1;
                } catch (NumberFormatException e) {
                    nextNumber = 1;
                }
            }
        }

        return String.format("ЛД-%d-%03d", currentYear, nextNumber);
    }

    @Transactional
    public Contract updateContract(Long contractId, UpdateContractRequest request) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));

        Client client = clientRepository.findById(request.getClientId())
                .orElseThrow(() -> new EntityNotFoundException("Клиент не найден с id: " + request.getClientId()));

        Equipment equipment = equipmentRepository.findById(request.getEquipmentId())
                .orElseThrow(() -> new EntityNotFoundException("Оборудование не найдено с id: " + request.getEquipmentId()));

        contract.setContractNumber(request.getContractNumber());
        contract.setClient(client);
        contract.setEquipment(equipment);
        contract.setStartDate(request.getStartDate());
        contract.setEndDate(request.getEndDate());
        contract.setTotalAmount(request.getTotalAmount());
        contract.setInterestRate(request.getInterestRate());
        contract.setPaymentPeriodMonths(request.getPeriodMonths());
        contract.setDescription(request.getDescription());

        return contractRepository.save(contract);
    }

    @Transactional
    public Contract changeStatus(Long contractId, ChangeContractStatusRequest request) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));

        Contract.ContractStatus oldStatus = contract.getStatus();
        Contract.ContractStatus newStatus = request.getStatus();

        contract.setStatus(newStatus);

        // Автоматическое изменение статуса оборудования
        Equipment equipment = contract.getEquipment();
        if (equipment != null) {
            // При активации договора - оборудование переходит в статус "В лизинге"
            if (newStatus == Contract.ContractStatus.ACTIVE && oldStatus != Contract.ContractStatus.ACTIVE) {
                equipment.setStatus(EquipmentStatus.LEASED);
                equipmentRepository.save(equipment);
            }
            // При завершении или отмене договора - оборудование возвращается в статус "Доступно"
            else if ((newStatus == Contract.ContractStatus.CLOSED || newStatus == Contract.ContractStatus.CANCELLED)
                     && oldStatus == Contract.ContractStatus.ACTIVE) {
                equipment.setStatus(EquipmentStatus.AVAILABLE);
                equipmentRepository.save(equipment);
            }
        }

        return contractRepository.save(contract);
    }

    @Transactional
    public void delete(Long contractId) {
        if (!contractRepository.existsById(contractId)) {
            throw new EntityNotFoundException("Договор не найден с id: " + contractId);
        }
        contractRepository.deleteById(contractId);
    }

    /**
     * Генерация графика платежей по договору
     * Аннуитетные платежи (равные суммы)
     */
    @Transactional
    public List<PaymentSchedule> generatePaymentSchedule(GeneratePaymentScheduleRequest request) {
        Contract contract = contractRepository.findById(request.getContractId())
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + request.getContractId()));

        // Удаляем существующие графики
        paymentScheduleRepository.deleteByContractId(contract.getId());

        Integer periodsObj = request.getPeriods() != null ? request.getPeriods() : contract.getPaymentPeriodMonths();
        if (periodsObj == null || periodsObj <= 0) {
            throw new IllegalArgumentException("Необходимо указать количество периодов");
        }
        int periods = periodsObj;

        BigDecimal totalAmount = contract.getTotalAmount();
        BigDecimal annualRate = contract.getInterestRate();
        
        // Месячная процентная ставка
        BigDecimal monthlyRate = annualRate != null 
            ? annualRate.divide(BigDecimal.valueOf(100), 10, BigDecimal.ROUND_HALF_UP)
                      .divide(BigDecimal.valueOf(12), 10, BigDecimal.ROUND_HALF_UP)
            : BigDecimal.ZERO;

        // Аннуитетный коэффициент: A = P * (r * (1+r)^n) / ((1+r)^n - 1)
        BigDecimal one = BigDecimal.ONE;
        BigDecimal onePlusR = one.add(monthlyRate);
        BigDecimal onePlusRpowN = onePlusR.pow(periods);
        BigDecimal annuityFactor = monthlyRate.multiply(onePlusRpowN)
                .divide(onePlusRpowN.subtract(one), 10, BigDecimal.ROUND_HALF_UP);

        // Ежемесячный платёж
        BigDecimal monthlyPayment = totalAmount.multiply(annuityFactor)
                .setScale(2, BigDecimal.ROUND_HALF_UP);

        LocalDate startDate = contract.getStartDate();
        BigDecimal remainingPrincipal = totalAmount;

        for (int i = 1; i <= periods; i++) {
            // Дата платежа - i-й месяц от даты начала
            LocalDate paymentDate = startDate.plusMonths(i);

            // Проценты за период
            BigDecimal interestPart = remainingPrincipal.multiply(monthlyRate)
                    .setScale(2, BigDecimal.ROUND_HALF_UP);

            // Основной долг
            BigDecimal principalPart = monthlyPayment.subtract(interestPart);

            // Для последнего платежа корректируем, чтобы избежать копеек
            if (i == periods) {
                principalPart = remainingPrincipal;
                monthlyPayment = principalPart.add(interestPart);
            }

            PaymentSchedule schedule = PaymentSchedule.builder()
                    .contract(contract)
                    .periodNumber(i)
                    .paymentDate(paymentDate)
                    .totalAmount(monthlyPayment)
                    .principalPart(principalPart)
                    .interestPart(interestPart)
                    .status(PaymentScheduleStatus.PENDING)
                    .build();

            // Создаём связанный платеж
            Payment payment = Payment.builder()
                    .schedule(schedule)
                    .contract(contract)
                    .amount(monthlyPayment)
                    .dueDate(paymentDate.atStartOfDay())
                    .paymentType(Payment.PaymentType.PRINCIPAL)
                    .status(Payment.PaymentStatus.PENDING)
                    .build();

            schedule.addPayment(payment);
            paymentScheduleRepository.save(schedule);

            remainingPrincipal = remainingPrincipal.subtract(principalPart);
        }

        return paymentScheduleRepository.findByContractId(contract.getId());
    }

    /**
     * Получение статистики по договору
     */
    @Transactional(readOnly = true)
    public ContractStatisticsDto getContractStatistics(Long contractId) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + contractId));

        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contractId);

        BigDecimal totalAmount = contract.getTotalAmount();
        BigDecimal paidAmount = BigDecimal.ZERO;
        int totalPayments = schedules.size();
        int paidPayments = 0;
        int overduePayments = 0;

        for (PaymentSchedule schedule : schedules) {
            if (schedule.getStatus() == PaymentScheduleStatus.PAID) {
                paidAmount = paidAmount.add(schedule.getTotalAmount());
                paidPayments++;
            } else if (schedule.getStatus() == PaymentScheduleStatus.OVERDUE) {
                overduePayments++;
            }
        }

        BigDecimal remainingAmount = totalAmount.subtract(paidAmount);

        return ContractStatisticsDto.builder()
                .totalAmount(totalAmount)
                .paidAmount(paidAmount)
                .remainingAmount(remainingAmount)
                .totalPayments(totalPayments)
                .paidPayments(paidPayments)
                .overduePayments(overduePayments)
                .build();
    }
}
