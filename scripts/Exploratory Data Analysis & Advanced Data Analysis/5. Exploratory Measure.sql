/*
=======================================
Exploratory Measure
=======================================

	to calculate the key metric of the business (Big NUmbers)
		- highest level of aggregation | lowest level of details
==========================================================
*/

-- task --
-- 1. Find the total sales
-- 2. find how many items are sold
-- 3. find the average selling price
-- 4. find the total number of orders 
-- 5. find the total number of products
-- 6. find the total number of customers
-- 7. find the total number of customers that has placed an order 


-- 1. Find the total sales
SELECT 
	SUM(sales_amount) total_sales
FROM gold.fact_sales

-- 2. find how many items are sold
SELECT 
	SUM(quantity) total_items_sold
FROM gold.fact_sales

-- 3. find the average selling price
SELECT
	AVG(sales_amount) avg_sales
FROM gold.fact_sales

-- 4. find the total number of orders 
	SELECT
		COUNT(order_number) total_order
	FROM gold.fact_sales -- ini kadang masih ada yang duplicates
	----
	SELECT
		COUNT(DISTINCT order_number) total_order
	FROM gold.fact_sales -- lebih baik ini karena order number jangan diduplikasi

-- 5. find the total number of products
SELECT 
	COUNT(DISTINCT(product_number)) total_product_number
FROM gold.dim_products

-- 6. find the total number of customers
SELECT
	COUNT(customer_id) total_customers,
	COUNT(DISTINCT customer_id) total_customers_distinct
FROM gold.dim_customers

-- 7. find the total number of customers that has placed an order 
SELECT
	COUNT(DISTINCT dc.customer_id) total_customers_buy
FROM gold.dim_customers dc
LEFT JOIN gold.fact_sales fc
ON dc.customer_key = fc.customer_key
WHERE fc.order_number IS NOT NULL

-- TASK 8
-- generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS 'Measure Name',  SUM(sales_amount) AS 'Measure Value'FROM gold.fact_sales
UNION ALL
SELECT 'Total Items Sold', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Sales', AVG(sales_amount) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Product Number', COUNT(DISTINCT product_number) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Total Customer Buy', COUNT(DISTINCT customer_id) total_customers_distinct FROM gold.dim_customers;