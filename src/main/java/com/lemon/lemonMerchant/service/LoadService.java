package com.lemon.lemonMerchant.service;


import com.lemon.lemonMerchant.entity.Load;
import com.lemon.lemonMerchant.repository.LoadRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LoadService {
    private final LoadRepository loadRepository;

    public LoadService(LoadRepository loadRepository) {
        this.loadRepository = loadRepository;
    }

    public Load save(Load load) {
        return loadRepository.save(load);
    }

    public Optional<Load> getById(Long id) {
        return loadRepository.findById(id);
    }

    public List<Load> getAll() {
        return loadRepository.findAll();
    }

    public void delete(Long id) {
        loadRepository.deleteById(id);
    }

    public Load update(Long id, Load load) {
        load.setId(id);
        return loadRepository.save(load);
    }
}