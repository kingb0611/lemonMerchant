package com.lemon.lemonMerchant.service;


import com.lemon.lemonMerchant.entity.Payment;
import com.lemon.lemonMerchant.repository.PaymentRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {
    private final PaymentRepository paymentRepository;

    public PaymentService(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    public Payment save(Payment payment) {
        return paymentRepository.save(payment);
    }

    public Optional<Payment> getById(Long id) {
        return paymentRepository.findById(id);
    }

    public List<Payment> getAll() {
        return paymentRepository.findAll();
    }

    public void delete(Long id) {
        paymentRepository.deleteById(id);
    }

    public Payment update(Long id, Payment payment) {
        payment.setId(id);
        return paymentRepository.save(payment);
    }
}
