package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Payment.RegisterPaymentRequest;
import com.LeaseManager.Dto.Payment.PaymentResponse;
import com.LeaseManager.Dto.PaymentDto;
import com.LeaseManager.Entity.Payment;
import com.LeaseManager.Service.PaymentService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @GetMapping
    public ResponseEntity<List<PaymentResponse>> getAllPayments() {
        return ResponseEntity.ok(paymentService.getAllPayments());
    }

    @GetMapping("/contract/{contractId}")
    public ResponseEntity<List<PaymentResponse>> getPaymentsByContractId(@PathVariable Long contractId) {
        return ResponseEntity.ok(paymentService.getPaymentsByContractId(contractId));
    }

    @PostMapping("/register")
    public ResponseEntity<PaymentResponse> registerPayment(
            @Valid @RequestBody RegisterPaymentRequest request) {
        PaymentResponse response = paymentService.registerPayment(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping
    public ResponseEntity<PaymentResponse> createPayment(@RequestBody PaymentDto paymentDto) {
        Payment created = paymentService.createPayment(paymentDto);
        PaymentResponse response = paymentService.toResponse(created);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/{id}/pay")
    public ResponseEntity<PaymentResponse> markPaymentAsPaid(@PathVariable Long id) {
        try {
            Payment payment = paymentService.markAsPaid(id);
            return ResponseEntity.ok(paymentService.toResponse(payment));
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePayment(@PathVariable Long id) {
        try {
            paymentService.delete(id);
            return ResponseEntity.noContent().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
