-- Star Schema Design for Retail Data Warehouse

-- 1. Dimension Tables

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL -- Standardized (e.g., 'Groceries' instead of 'Grocery')
);

CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(100) NOT NULL -- Cleaned NULL values by mapping store names
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL,
    day_name VARCHAR(20) NOT NULL
);

-- 2. Fact Table

CREATE TABLE fact_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    date_key INT NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_sales_amount DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Inserting Dimension Data (Cleaned and Standardized)
INSERT INTO dim_product (product_id, product_name, category) VALUES
(1, 'Speaker', 'Electronics'),
(2, 'Tablet', 'Electronics'),
(3, 'Phone', 'Electronics'),
(4, 'Smartwatch', 'Electronics'),
(5, 'Atta 10kg', 'Groceries');

INSERT INTO dim_store (store_id, store_name, store_city) VALUES
(1, 'Chennai Anna', 'Chennai'),
(2, 'Delhi South', 'Delhi'),
(3, 'Bangalore MG', 'Bangalore'),
(4, 'Pune FC Road', 'Pune'),
(5, 'Mumbai Central', 'Mumbai');

INSERT INTO dim_date (date_key, full_date, year, month, day, quarter, day_name) VALUES
(20230829, '2023-08-29', 2023, 8, 29, 3, 'Tuesday'),
(20231212, '2023-12-12', 2023, 12, 12, 4, 'Tuesday'),
(20230205, '2023-02-05', 2023, 2, 5, 1, 'Sunday'),
(20230220, '2023-02-20', 2023, 2, 20, 1, 'Monday'),
(20230115, '2023-01-15', 2023, 1, 15, 1, 'Sunday'),
(20230809, '2023-08-09', 2023, 8, 9, 3, 'Wednesday'),
(20230331, '2023-03-31', 2023, 3, 31, 1, 'Friday'),
(20231026, '2023-10-26', 2023, 10, 26, 4, 'Thursday'),
(20231208, '2023-12-08', 2023, 12, 8, 4, 'Friday');

-- Inserting Fact Data (10 Rows)

INSERT INTO fact_sales (transaction_id, date_key, store_id, product_id, units_sold, unit_price, total_sales_amount) VALUES
('TXN5000', 20230829, 1, 1, 3, 49262.78, 147788.34),
('TXN5001', 20231212, 1, 2, 11, .12, 255487.32),
('TXN5002', 20230205, 1, 3, 20, 48703.39, 974067.80),
('TXN5003', 20230220, 2, 2, 14, 23226.12, 325165.68),
('TXN5004', 20230115, 1, 4, 10, 58851.01, 588510.10),
('TXN5005', 20230809, 3, 5, 12, 52464.00, 629568.00),
('TXN5006', 20230331, 4, 4, 6, 58851.01, 353106.06),
('TXN5007', 20231026, 4, 4, 15, 58851.01, 882765.15),
('TXN5008', 20231208, 1, 2, 11, 23226.12, 255487.32),
('TXN5009', 20230829, 1, 2, 15, 23226.12, 348391.80);