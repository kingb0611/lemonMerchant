package com.lemon.lemonMerchant.entity;



import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "loads")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class Load {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "farmer_id")
    private Farmer farmer;

    private LocalDate date;
    private Double quantity;
    private Double ratePerUnit;
    private Double totalAmount;
    private Double commissionPct;
    private Double amountPaid;
    private Double pendingCredit;
    private String notes;

    // getters and setters
}
