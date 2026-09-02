package com.LeaseManager.Service.Payment;

import com.LeaseManager.Dto.Payment.RegisterPaymentRequest;
import com.LeaseManager.Dto.Payment.PaymentResponse;
import com.LeaseManager.Dto.PaymentDto;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Payment;

import java.util.List;

public interface PaymentService {
    List<PaymentResponse> getAllPayments();

    List<PaymentResponse> getPaymentsByContractId(Long contractId);

    Payment getPaymentById(Long paymentId);

    Payment createPayment(PaymentDto paymentDto);

    PaymentResponse registerPayment(RegisterPaymentRequest request);

    Payment markAsPaid(Long paymentId);

    PaymentResponse toResponse(Payment payment);

    List<Payment> generatePaymentsForContract(Contract contract);

    void delete(Long paymentId);
}
