package com.lemon.lemonMerchant.service;



import com.lemon.lemonMerchant.entity.Sale;
import com.lemon.lemonMerchant.repository.SaleRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SaleService {
    private final SaleRepository saleRepository;

    public SaleService(SaleRepository saleRepository) {
        this.saleRepository = saleRepository;
    }

    public Sale save(Sale sale) {
        return saleRepository.save(sale);
    }

    public Optional<Sale> getById(Long id) {
        return saleRepository.findById(id);
    }

    public List<Sale> getAll() {
        return saleRepository.findAll();
    }

    public void delete(Long id) {
        saleRepository.deleteById(id);
    }

    public Sale update(Long id, Sale sale) {
        sale.setId(id);
        return saleRepository.save(sale);
    }
}
