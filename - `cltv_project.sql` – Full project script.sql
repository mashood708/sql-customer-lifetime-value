
--  Step 1: Create the Orders Table
CREATE DATABASE IF NOT EXISTS cltv_project;
USE cltv_project;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    order_date DATE,
    order_amount DECIMAL(10,2)
);

-- Step 2: Insert Sample Data
INSERT INTO orders (order_id, customer_name, region, order_date, order_amount) VALUES
(1, 'Ali', 'North', '2024-01-05', 3000),
(2, 'Ali', 'North', '2024-02-15', 4500),
(3, 'Sara', 'South', '2024-01-20', 2500),
(4, 'Sara', 'South', '2024-03-10', 5000),
(5, 'John', 'North', '2024-01-12', 7000),
(6, 'John', 'North', '2024-02-17', 2000),
(7, 'Fatima', 'South', '2024-01-30', 6000),
(8, 'Fatima', 'South', '2024-02-28', 6500),
(9, 'Ali', 'North', '2024-03-01', 3000),
(10, 'Sara', 'South', '2024-04-05', 5500);

--  Step 3: Customer Lifetime Value (CLTV) Calculation
SELECT
    customer_name,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spend,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS customer_lifetime_days,
    CASE 
        WHEN SUM(order_amount) >= 10000 THEN 'High Value'
        WHEN SUM(order_amount) >= 6000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment
FROM orders
GROUP BY customer_name
ORDER BY total_spend DESC;

-- Step 4: Rank Customers by Total Spend (Error-Free)
SELECT *,
       RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM (
    SELECT
        customer_name,
        SUM(order_amount) AS total_spend
    FROM orders
    GROUP BY customer_name
) AS customer_summary;

--  Step 5: Optional - Save as View
CREATE OR REPLACE VIEW cltv_summary AS
SELECT
    customer_name,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spend,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS customer_lifetime_days,
    CASE 
        WHEN SUM(order_amount) >= 10000 THEN 'High Value'
        WHEN SUM(order_amount) >= 6000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment
FROM orders
GROUP BY customer_name;
