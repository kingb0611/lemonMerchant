package com.lemon.lemonMerchant.repository;


import com.lemon.lemonMerchant.entity.Sale;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SaleRepository extends JpaRepository<Sale, Long> {
}
