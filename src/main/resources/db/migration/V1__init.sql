-- src/main/resources/db/migration/V1__init.sql

CREATE TABLE farmers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  location VARCHAR(255),
  default_commission_pct DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loads (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  farmer_id BIGINT NOT NULL,
  date DATE NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  rate_per_unit DECIMAL(10,2) NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  commission_pct DECIMAL(5,2),
  amount_paid DECIMAL(12,2),
  pending_credit DECIMAL(12,2),
  notes TEXT,
  CONSTRAINT fk_loads_farmer FOREIGN KEY (farmer_id) REFERENCES farmers(id)
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  farmer_id BIGINT NOT NULL,
  date DATE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  method VARCHAR(50),
  notes TEXT,
  CONSTRAINT fk_payments_farmer FOREIGN KEY (farmer_id) REFERENCES farmers(id)
);

CREATE TABLE sales (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  date DATE NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  price_per_unit DECIMAL(10,2) NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  notes TEXT
);