package com.LeaseManager.Service.PaymentSchedule;

import com.LeaseManager.Dto.PaymentSchedule.CreatePaymentScheduleRequest;
import com.LeaseManager.Dto.PaymentSchedule.MarkAsPaidRequest;
import com.LeaseManager.Dto.PaymentSchedule.PaymentScheduleResponse;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.EquipmentStatus;
import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.EquipmentRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PaymentScheduleService {

    private final PaymentScheduleRepository paymentScheduleRepository;
    private final ContractRepository contractRepository;
    private final EquipmentRepository equipmentRepository;

    public PaymentScheduleService(PaymentScheduleRepository paymentScheduleRepository,
                                  ContractRepository contractRepository,
                                  EquipmentRepository equipmentRepository) {
        this.paymentScheduleRepository = paymentScheduleRepository;
        this.contractRepository = contractRepository;
        this.equipmentRepository = equipmentRepository;
    }

    @Transactional
    public PaymentScheduleResponse createSchedule(CreatePaymentScheduleRequest request) {
        Contract contract = contractRepository.findById(request.getContractId())
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + request.getContractId()));

        PaymentSchedule schedule = PaymentSchedule.builder()
                .contract(contract)
                .periodNumber(request.getPeriodNumber())
                .paymentDate(request.getPaymentDate())
                .totalAmount(request.getTotalAmount())
                .principalPart(request.getPrincipalPart())
                .interestPart(request.getInterestPart())
                .status(PaymentScheduleStatus.PENDING)
                .build();

        Payment payment = Payment.builder()
                .schedule(schedule)
                .contract(contract)
                .amount(request.getTotalAmount())
                .dueDate(request.getPaymentDate().atStartOfDay())
                .paymentType(Payment.PaymentType.PRINCIPAL)
                .status(Payment.PaymentStatus.PENDING)
                .build();

        schedule.addPayment(payment);

        PaymentSchedule saved = paymentScheduleRepository.save(schedule);

        return PaymentScheduleResponse.builder()
                .id(saved.getId())
                .contractId(saved.getContract().getId())
                .periodNumber(saved.getPeriodNumber())
                .paymentDate(saved.getPaymentDate())
                .totalAmount(saved.getTotalAmount())
                .principalPart(saved.getPrincipalPart())
                .interestPart(saved.getInterestPart())
                .status(saved.getStatus())
                .overdue(false)
                .build();
    }

    @Transactional(readOnly = true)
    public List<PaymentScheduleResponse> getSchedulesByContractId(Long contractId) {
        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contractId);
        LocalDate now = LocalDate.now();

        return schedules.stream()
                .map(schedule -> {
                    boolean isOverdue = schedule.getPaymentDate().isBefore(now) &&
                            schedule.getStatus() != PaymentScheduleStatus.PAID &&
                            schedule.getStatus() != PaymentScheduleStatus.CANCELLED;

                    return PaymentScheduleResponse.builder()
                            .id(schedule.getId())
                            .contractId(schedule.getContract().getId())
                            .periodNumber(schedule.getPeriodNumber())
                            .paymentDate(schedule.getPaymentDate())
                            .totalAmount(schedule.getTotalAmount())
                            .principalPart(schedule.getPrincipalPart())
                            .interestPart(schedule.getInterestPart())
                            .status(schedule.getStatus())
                            .overdue(isOverdue)
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PaymentScheduleResponse> getOverdueSchedules() {
        LocalDate now = LocalDate.now();
        List<PaymentSchedule> overdueSchedules = paymentScheduleRepository.findAllByStatus(PaymentScheduleStatus.OVERDUE);

        List<PaymentSchedule> pendingSchedules = paymentScheduleRepository.findByStatus(PaymentScheduleStatus.PENDING);
        for (PaymentSchedule schedule : pendingSchedules) {
            if (schedule.getPaymentDate().isBefore(now) && !overdueSchedules.contains(schedule)) {
                schedule.setStatus(PaymentScheduleStatus.OVERDUE);
                paymentScheduleRepository.save(schedule);
                overdueSchedules.add(schedule);
            }
        }

        return overdueSchedules.stream()
                .map(schedule -> PaymentScheduleResponse.builder()
                        .id(schedule.getId())
                        .contractId(schedule.getContract().getId())
                        .periodNumber(schedule.getPeriodNumber())
                        .paymentDate(schedule.getPaymentDate())
                        .totalAmount(schedule.getTotalAmount())
                        .principalPart(schedule.getPrincipalPart())
                        .interestPart(schedule.getInterestPart())
                        .status(schedule.getStatus())
                        .overdue(true)
                        .build())
                .collect(Collectors.toList());
    }

    @Transactional
    public PaymentScheduleResponse markAsPaid(Long scheduleId, MarkAsPaidRequest request) {
        PaymentSchedule schedule = paymentScheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new EntityNotFoundException("График платежа не найден с id: " + scheduleId));

        schedule.setStatus(PaymentScheduleStatus.PAID);

        schedule.getPayments().forEach(payment -> {
            if (payment.getStatus() == com.LeaseManager.Entity.Payment.PaymentStatus.PENDING) {
                payment.setStatus(com.LeaseManager.Entity.Payment.PaymentStatus.PAID);
                payment.setPaidDate(java.time.LocalDateTime.now());
                if (request.getComment() != null && !request.getComment().isEmpty()) {
                    payment.setComment(request.getComment());
                }
            }
        });

        PaymentSchedule updated = paymentScheduleRepository.save(schedule);

        checkAndCompleteContract(updated.getContract());

        return PaymentScheduleResponse.builder()
                .id(updated.getId())
                .contractId(updated.getContract().getId())
                .periodNumber(updated.getPeriodNumber())
                .paymentDate(updated.getPaymentDate())
                .totalAmount(updated.getTotalAmount())
                .principalPart(updated.getPrincipalPart())
                .interestPart(updated.getInterestPart())
                .status(updated.getStatus())
                .overdue(false)
                .build();
    }

    private void checkAndCompleteContract(Contract contract) {
        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contract.getId());

        if (schedules.isEmpty()) {
            return;
        }

        boolean allPaid = schedules.stream()
                .allMatch(s -> s.getStatus() == PaymentScheduleStatus.PAID);

        if (allPaid && contract.getStatus() == Contract.ContractStatus.ACTIVE) {
            contract.setStatus(Contract.ContractStatus.CLOSED);
            contractRepository.save(contract);

            Equipment equipment = contract.getEquipment();
            if (equipment != null && equipment.getStatus() == EquipmentStatus.LEASED) {
                equipment.setStatus(EquipmentStatus.AVAILABLE);
                equipmentRepository.save(equipment);
            }
        }
    }

    @Transactional
    public PaymentScheduleResponse cancelSchedule(Long scheduleId) {
        PaymentSchedule schedule = paymentScheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new EntityNotFoundException("График платежа не найден с id: " + scheduleId));

        schedule.setStatus(PaymentScheduleStatus.CANCELLED);

        schedule.getPayments().forEach(payment -> {
            if (payment.getStatus() != com.LeaseManager.Entity.Payment.PaymentStatus.PAID) {
                payment.setStatus(com.LeaseManager.Entity.Payment.PaymentStatus.CANCELLED);
            }
        });

        PaymentSchedule updated = paymentScheduleRepository.save(schedule);

        return PaymentScheduleResponse.builder()
                .id(updated.getId())
                .contractId(updated.getContract().getId())
                .periodNumber(updated.getPeriodNumber())
                .paymentDate(updated.getPaymentDate())
                .totalAmount(updated.getTotalAmount())
                .principalPart(updated.getPrincipalPart())
                .interestPart(updated.getInterestPart())
                .status(updated.getStatus())
                .overdue(false)
                .build();
    }
}
