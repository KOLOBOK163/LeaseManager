package com.LeaseManager.Service.Payment;

import com.LeaseManager.Dto.Payment.RegisterPaymentRequest;
import com.LeaseManager.Dto.Payment.PaymentResponse;
import com.LeaseManager.Dto.PaymentDto;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Mapper.EntityMapper;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.PaymentRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PaymentServiceImpl implements PaymentService {

    private final PaymentRepository paymentRepository;
    private final ContractRepository contractRepository;
    private final PaymentScheduleRepository paymentScheduleRepository;
    private final EntityMapper entityMapper;

    public PaymentServiceImpl(PaymentRepository paymentRepository,
                              ContractRepository contractRepository,
                              PaymentScheduleRepository paymentScheduleRepository,
                              EntityMapper entityMapper) {
        this.paymentRepository = paymentRepository;
        this.contractRepository = contractRepository;
        this.paymentScheduleRepository = paymentScheduleRepository;
        this.entityMapper = entityMapper;
    }

    @Override
    public List<PaymentResponse> getAllPayments() {
        return paymentRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<PaymentResponse> getPaymentsByContractId(Long contractId) {
        return paymentRepository.findByContractId(contractId).stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public Payment getPaymentById(Long paymentId) {
        return paymentRepository.findById(paymentId)
                .orElseThrow(() -> new EntityNotFoundException("Платёж не найден с id: " + paymentId));
    }

    @Override
    @Transactional
    public Payment createPayment(PaymentDto paymentDto) {
        Contract contract = contractRepository.findById(paymentDto.getContractId())
                .orElseThrow(() -> new EntityNotFoundException("Договор не найден с id: " + paymentDto.getContractId()));

        Payment payment = entityMapper.toEntity(paymentDto);
        payment.setContract(contract);
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public PaymentResponse registerPayment(RegisterPaymentRequest request) {
        PaymentSchedule schedule = paymentScheduleRepository.findById(request.getScheduleId())
                .orElseThrow(() -> new EntityNotFoundException("График платежа не найден с id: " + request.getScheduleId()));

        if (schedule.getStatus() == PaymentScheduleStatus.PAID) {
            throw new IllegalArgumentException("График платежа уже оплачен");
        }

        Payment payment = Payment.builder()
                .schedule(schedule)
                .contract(schedule.getContract())
                .amount(request.getAmount())
                .dueDate(LocalDateTime.now())
                .paidDate(request.getPaymentDate())
                .paymentType(request.getPaymentType() != null ? request.getPaymentType() : Payment.PaymentType.PRINCIPAL)
                .paymentMethod(request.getPaymentMethod())
                .status(Payment.PaymentStatus.PAID)
                .comment(request.getComment())
                .build();

        if (request.getDocumentNumber() != null && !request.getDocumentNumber().isBlank()) {
            payment.setComment((request.getComment() != null ? request.getComment() + ". " : "") 
                + "Документ: " + request.getDocumentNumber());
        }

        paymentRepository.save(payment);

        updateScheduleStatus(schedule);

        if (schedule.getPayments().isEmpty() || schedule.getStatus() == PaymentScheduleStatus.PENDING) {
            schedule.setStatus(PaymentScheduleStatus.PAID);
            paymentScheduleRepository.save(schedule);
        }

        checkAndCompleteContract(schedule.getContract());

        return toResponse(payment);
    }

    @Override
    @Transactional
    public Payment markAsPaid(Long paymentId) {
        Payment payment = getPaymentById(paymentId);
        payment.markAsPaid();

        if (payment.getSchedule() != null) {
            updateScheduleStatus(payment.getSchedule());
        }

        return paymentRepository.save(payment);
    }

    @Override
    public PaymentResponse toResponse(Payment payment) {
        return PaymentResponse.builder()
                .id(payment.getId())
                .scheduleId(payment.getSchedule() != null ? payment.getSchedule().getId() : null)
                .contractId(payment.getContract().getId())
                .contractNumber(payment.getContract().getContractNumber())
                .periodNumber(payment.getSchedule() != null ? payment.getSchedule().getPeriodNumber() : null)
                .amount(payment.getAmount())
                .dueDate(payment.getDueDate())
                .paidDate(payment.getPaidDate())
                .paymentType(payment.getPaymentType())
                .paymentMethod(payment.getPaymentMethod())
                .status(payment.getStatus())
                .comment(payment.getComment())
                .build();
    }

    @Override
    @Transactional
    public void delete(Long paymentId) {
        if (!paymentRepository.existsById(paymentId)) {
            throw new EntityNotFoundException("Платёж не найден с id: " + paymentId);
        }
        paymentRepository.deleteById(paymentId);
    }

    private void updateScheduleStatus(PaymentSchedule schedule) {
        List<Payment> payments = schedule.getPayments();

        if (payments.isEmpty()) {
            return;
        }

        BigDecimal totalPaid = payments.stream()
                .filter(Payment::isPaid)
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal scheduleTotal = schedule.getTotalAmount();

        if (totalPaid.compareTo(scheduleTotal) >= 0) {
            schedule.setStatus(PaymentScheduleStatus.PAID);
        }
        else if (totalPaid.compareTo(BigDecimal.ZERO) > 0) {
            schedule.setStatus(PaymentScheduleStatus.PARTIAL);
        }

        paymentScheduleRepository.save(schedule);
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
        }
    }

    @Override
    @Transactional
    public List<Payment> generatePaymentsForContract(Contract contract) {
        List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contract.getId());

        for (PaymentSchedule schedule : schedules) {
            Payment payment = Payment.builder()
                    .schedule(schedule)
                    .contract(contract)
                    .amount(schedule.getTotalAmount())
                    .dueDate(schedule.getPaymentDate().atStartOfDay())
                    .status(Payment.PaymentStatus.PENDING)
                    .paymentType(Payment.PaymentType.PRINCIPAL)
                    .build();

            schedule.addPayment(payment);
            paymentRepository.save(payment);
        }

        return contract.getPayments();
    }
}
