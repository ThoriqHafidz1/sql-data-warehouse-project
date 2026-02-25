/* 
============================
Data Segmentation Analysis:
	--> group the adata based on specifi range
	- untuk memahami korelasi antara 2 measures
============================
*/

-- TASK 1 --
-- segment products into cost ranges and
-- count how many products fall into each segment

WITH products_segmentations AS
	(SELECT 
		product_key,
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
			ELSE 'Above 1000'
		END cost_segmentation
	FROM gold.dim_products 
)
SELECT
	cost_segmentation,
	COUNT(*) total_products
FROM products_segmentations 
GROUP BY cost_segmentation;

-- TASK 2 --
-- GROUP customers into three segmentation based on their spending behaviour 
-- 1. VIP: customers with at least 12 months of history and spending more than 5000
-- 2. Regular: customers with at least 12 months of history and spending 5000 or less
-- 3. New: customers with with lifespan less than 12 months 

WITH customers_sales AS
	(SELECT 
		dc.customer_id,
		dc.first_name,
		dc.last_name,
		dc.country,
		DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) month_history,
		SUM(fs.sales_amount) total_sales
	FROM gold.dim_customers dc
	LEFT JOIN gold.fact_sales fs
	ON dc.customer_key = fs.customer_key
	GROUP BY dc.customer_id,
		dc.first_name,
		dc.last_name,
		dc.country,
		DATEDIFF(YEAR, YEAR(fs.order_date), GETDATE())
	)
SELECT 
	*,
	CASE
		WHEN total_sales >= 5000 AND month_history >=12 THEN 'VIP'
		WHEN total_sales < 5000 AND month_history >= 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_segmentations
FROM customers_sales
ORDER BY total_sales DESC;
-- cara 2 dari bang barraa
WITH customers_sales AS
	(SELECT 
		dc.customer_key,
		MIN(fs.order_date) first_order,
		MAX(fs.order_date) last_order,
		DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) life_span,
		SUM(sales_amount) total_sales
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers dc
	ON fs.customer_key = dc.customer_key
	GROUP BY dc.customer_key
	)
SELECT 
	customers_segments,
	COUNT(*) total_customers
FROM 
	(SELECT 
		customer_key,
		life_span,
		total_sales,
		CASE
			WHEN life_span >= 12 AND total_sales >= 5000 THEN 'VIP'
			WHEN life_span >= 12 AND total_sales < 5000 THEN 'Regular'
			ELSE 'New'
		END AS customers_segments
	FROM customers_sales
	)t
GROUP BY customers_segments
ORDER BY total_customers DESC
