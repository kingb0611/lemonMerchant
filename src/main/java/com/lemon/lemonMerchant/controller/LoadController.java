package com.lemon.lemonMerchant.controller;


import com.lemon.lemonMerchant.entity.Load;
import com.lemon.lemonMerchant.service.LoadService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/loads")
public class LoadController {
    private final LoadService loadService;

    public LoadController(LoadService loadService) {
        this.loadService = loadService;
    }

    @PostMapping
    public ResponseEntity<Load> create(@RequestBody Load load) {
        return ResponseEntity.ok(loadService.save(load));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Load> getById(@PathVariable Long id) {
        return loadService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public List<Load> getAll() {
        return loadService.getAll();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Load> update(@PathVariable Long id, @RequestBody Load load) {
        return ResponseEntity.ok(loadService.update(id, load));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        loadService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
