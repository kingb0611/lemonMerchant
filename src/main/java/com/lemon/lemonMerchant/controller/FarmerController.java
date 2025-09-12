package com.lemon.lemonMerchant.controller;

import com.lemon.lemonMerchant.entity.Farmer;
import com.lemon.lemonMerchant.service.FarmerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/farmers")
public class FarmerController {
    private final FarmerService farmerService;

    public FarmerController(FarmerService farmerService) {
        this.farmerService = farmerService;
    }

    @PostMapping
    public ResponseEntity<Farmer> create(@RequestBody Farmer farmer) {
        return ResponseEntity.ok(farmerService.save(farmer));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Farmer> getById(@PathVariable Long id) {
        return farmerService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public List<Farmer> getAll() {
        return farmerService.getAll();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Farmer> update(@PathVariable Long id, @RequestBody Farmer farmer) {
        return ResponseEntity.ok(farmerService.update(id, farmer));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        farmerService.delete(id);
        return ResponseEntity.noContent().build();
    }
}