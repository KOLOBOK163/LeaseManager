package com.LeaseManager.Service.Dashboard;

import com.LeaseManager.Dto.Dashboard.DashboardStatsDto;
import com.LeaseManager.Dto.Dashboard.PaymentChartDto;
import com.LeaseManager.Dto.Dashboard.UpcomingPaymentDto;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Contract.ContractStatus;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.EquipmentStatus;
import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Entity.Payment.PaymentStatus;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Repository.ClientRepository;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.EquipmentRepository;
import com.LeaseManager.Repository.PaymentRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    private final ContractRepository contractRepository;
    private final ClientRepository clientRepository;
    private final PaymentRepository paymentRepository;
    private final EquipmentRepository equipmentRepository;
    private final PaymentScheduleRepository paymentScheduleRepository;

    public DashboardService(ContractRepository contractRepository,
                           ClientRepository clientRepository,
                           PaymentRepository paymentRepository,
                           EquipmentRepository equipmentRepository,
                           PaymentScheduleRepository paymentScheduleRepository) {
        this.contractRepository = contractRepository;
        this.clientRepository = clientRepository;
        this.paymentRepository = paymentRepository;
        this.equipmentRepository = equipmentRepository;
        this.paymentScheduleRepository = paymentScheduleRepository;
    }

    @Transactional(readOnly = true)
    public DashboardStatsDto getStats() {
        List<Contract> allContracts = contractRepository.findAll();
        long activeContracts = allContracts.stream()
                .filter(c -> c.getStatus() == ContractStatus.ACTIVE)
                .count();

        long totalClients = clientRepository.count();

        LocalDateTime now = LocalDateTime.now();
        List<PaymentSchedule> overdueSchedules = paymentScheduleRepository.findAllByStatus(PaymentScheduleStatus.OVERDUE);
        List<Payment> overduePayments = paymentRepository.findAllByStatus(PaymentStatus.PENDING);

        int overdueCount = overdueSchedules.size();
        for (Payment payment : overduePayments) {
            if (payment.getDueDate().isBefore(now)) {
                overdueCount++;
            }
        }

        List<Equipment> allEquipment = equipmentRepository.findAll();
        long freeEquipment = allEquipment.stream()
                .filter(e -> e.getStatus() == EquipmentStatus.AVAILABLE)
                .count();

        return DashboardStatsDto.builder()
                .activeContracts((int) activeContracts)
                .totalClients((int) totalClients)
                .overduePayments(overdueCount)
                .freeEquipment((int) freeEquipment)
                .build();
    }

    @Transactional(readOnly = true)
    public PaymentChartDto getPaymentChart() {
        List<String> months = new ArrayList<>();
        List<Double> amounts = new ArrayList<>();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");

        // Получаем последние 6 месяцев
        for (int i = 5; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusMonths(i);
            months.add(date.format(DateTimeFormatter.ofPattern("MMM yyyy")));

            // Сумма платежей за месяц
            LocalDateTime startOfMonth = date.withDayOfMonth(1).atStartOfDay();
            LocalDateTime endOfMonth = date.withDayOfMonth(date.lengthOfMonth()).atTime(23, 59, 59);

            List<Payment> paidPayments = paymentRepository.findAllByStatus(PaymentStatus.PAID);
            double totalAmount = paidPayments.stream()
                    .filter(p -> p.getPaidDate() != null)
                    .filter(p -> p.getPaidDate().isAfter(startOfMonth) && p.getPaidDate().isBefore(endOfMonth))
                    .mapToDouble(pay -> pay.getAmount().doubleValue())
                    .sum();

            amounts.add(totalAmount);
        }

        return PaymentChartDto.builder()
                .months(months)
                .amounts(amounts)
                .build();
    }

    @Transactional(readOnly = true)
    public List<UpcomingPaymentDto> getUpcomingPayments() {
        LocalDate today = LocalDate.now();
        LocalDate endDate = today.plusDays(7);

        // Получаем графики платежей на следующие 7 дней
        List<PaymentSchedule> upcomingSchedules = paymentScheduleRepository.findByPeriod(today, endDate);

        return upcomingSchedules.stream()
                .filter(ps -> ps.getStatus() == PaymentScheduleStatus.PENDING || ps.getStatus() == PaymentScheduleStatus.OVERDUE)
                .map(ps -> {
                    String clientName = ps.getContract().getClient().getFullName();
                    if (clientName == null || clientName.isEmpty()) {
                        clientName = ps.getContract().getClient().getCompanyName();
                    }
                    return UpcomingPaymentDto.builder()
                            .paymentScheduleId(ps.getId())
                            .contractId(ps.getContract().getId())
                            .contractNumber(ps.getContract().getContractNumber())
                            .clientName(clientName)
                            .paymentDate(ps.getPaymentDate())
                            .amount(ps.getTotalAmount())
                            .status(ps.getStatus().name())
                            .build();
                })
                .collect(Collectors.toList());
    }
}
