package com.lemon.lemonMerchant.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "farmers")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class Farmer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String phone;
    private String location;

    @Column(name = "default_commission_pct")
    private Double defaultCommissionPct;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // getters and setters
}
