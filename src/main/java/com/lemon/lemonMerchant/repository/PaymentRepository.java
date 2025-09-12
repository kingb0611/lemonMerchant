package com.lemon.lemonMerchant.repository;



import com.lemon.lemonMerchant.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
}
