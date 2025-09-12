-- Insert sample farmers
INSERT INTO farmers (name, phone, location, default_commission_pct, created_at) VALUES
('Ravi Kumar', '9876543210', 'Village A', 2.5, CURRENT_TIMESTAMP),
('Sita Devi', '9123456780', 'Village B', 3.0, CURRENT_TIMESTAMP),
('Amit Singh', '9988776655', 'Village C', 2.0, CURRENT_TIMESTAMP),
('Geeta Sharma', '9090909090', 'Village D', 2.8, CURRENT_TIMESTAMP),
('Manoj Yadav', '9191919191', 'Village E', 3.2, CURRENT_TIMESTAMP),
('Pooja Rani', '8888888888', 'Village F', 2.7, CURRENT_TIMESTAMP),
('Vikram Patel', '7777777777', 'Village G', 2.9, CURRENT_TIMESTAMP),
('Sunita Joshi', '6666666666', 'Village H', 3.1, CURRENT_TIMESTAMP),
('Rajesh Verma', '5555555555', 'Village I', 2.6, CURRENT_TIMESTAMP),
('Meena Kumari', '4444444444', 'Village J', 3.0, CURRENT_TIMESTAMP);

-- Insert sample loads
INSERT INTO loads (farmer_id, date, quantity, rate_per_unit, total_amount, commission_pct, amount_paid, pending_credit, notes) VALUES
(1, '2024-06-01', 100, 15.00, 1500.00, 2.5, 1000.00, 500.00, 'First load'),
(2, '2024-06-02', 80, 16.00, 1280.00, 3.0, 1280.00, 0.00, 'Paid in full'),
(3, '2024-06-03', 120, 14.50, 1740.00, 2.0, 1500.00, 240.00, 'Partial payment'),
(4, '2024-06-04', 90, 15.20, 1368.00, 2.8, 1368.00, 0.00, 'Full payment'),
(5, '2024-06-05', 110, 15.80, 1738.00, 3.2, 1000.00, 738.00, 'Pending balance'),
(6, '2024-06-06', 95, 16.00, 1520.00, 2.7, 1520.00, 0.00, 'Paid in full'),
(7, '2024-06-07', 105, 15.50, 1627.50, 2.9, 1200.00, 427.50, 'Partial payment'),
(8, '2024-06-08', 115, 16.20, 1863.00, 3.1, 1863.00, 0.00, 'Full payment'),
(9, '2024-06-09', 100, 15.70, 1570.00, 2.6, 1570.00, 0.00, 'Paid in full'),
(10, '2024-06-10', 85, 16.50, 1402.50, 3.0, 1000.00, 402.50, 'Pending payment');

-- Insert sample payments
INSERT INTO payments (farmer_id, date, amount, method, notes) VALUES
(1, '2024-06-03', 500.00, 'Cash', 'Balance payment'),
(2, '2024-06-02', 1280.00, 'UPI', 'Full payment'),
(3, '2024-06-04', 240.00, 'Bank', 'Partial payment'),
(4, '2024-06-04', 1368.00, 'Cash', 'Full payment'),
(5, '2024-06-06', 738.00, 'UPI', 'Pending balance'),
(6, '2024-06-06', 1520.00, 'Bank', 'Paid in full'),
(7, '2024-06-08', 427.50, 'Cash', 'Partial payment'),
(8, '2024-06-08', 1863.00, 'UPI', 'Full payment'),
(9, '2024-06-09', 1570.00, 'Bank', 'Paid in full'),
(10, '2024-06-11', 402.50, 'Cash', 'Pending payment');

-- Insert sample sales
INSERT INTO sales (date, quantity, price_per_unit, total_amount, notes) VALUES
('2024-06-04', 150, 18.00, 2700.00, 'Sold to Buyer X'),
('2024-06-05', 30, 19.00, 570.00, 'Sold to Buyer Y'),
('2024-06-06', 120, 17.50, 2100.00, 'Sold to Buyer Z'),
('2024-06-07', 90, 18.20, 1638.00, 'Sold to Buyer A'),
('2024-06-08', 110, 18.80, 2068.00, 'Sold to Buyer B'),
('2024-06-09', 95, 19.00, 1805.00, 'Sold to Buyer C'),
('2024-06-10', 105, 18.50, 1942.50, 'Sold to Buyer D'),
('2024-06-11', 115, 19.20, 2208.00, 'Sold to Buyer E'),
('2024-06-12', 100, 18.70, 1870.00, 'Sold to Buyer F'),
('2024-06-13', 85, 19.50, 1657.50, 'Sold to Buyer G');