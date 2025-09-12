package com.lemon.lemonMerchant.service;

import com.lemon.lemonMerchant.entity.Farmer;
import com.lemon.lemonMerchant.repository.FarmerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FarmerService {
    private final FarmerRepository farmerRepository;

    public FarmerService(FarmerRepository farmerRepository) {
        this.farmerRepository = farmerRepository;
    }

    public Farmer save(Farmer farmer) {
        return farmerRepository.save(farmer);
    }

    public Optional<Farmer> getById(Long id) {
        return farmerRepository.findById(id);
    }

    public List<Farmer> getAll() {
        return farmerRepository.findAll();
    }

    public void delete(Long id) {
        farmerRepository.deleteById(id);
    }

    public Farmer update(Long id, Farmer farmer) {
        farmer.setId(id);
        return farmerRepository.save(farmer);
    }
}