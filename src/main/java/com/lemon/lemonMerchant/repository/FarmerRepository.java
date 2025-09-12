package com.lemon.lemonMerchant.repository;


import com.lemon.lemonMerchant.entity.Farmer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FarmerRepository extends JpaRepository<Farmer, Long> {
}