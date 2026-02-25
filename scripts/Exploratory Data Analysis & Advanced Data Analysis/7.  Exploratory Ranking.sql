/*
=======================================
Exploratory Ranking
=======================================
	Merangking nilai dimension by measure
	- TOP N performers | BOTTOM N performers
		1. RANK
		2. DENSE_RANK
		3. ROW_NUMBER
==========================================================
*/


-- task 1 --
-- which 5 products generate the highest revenue

SELECT
	dp.product_id,
	dp.product_number,
	dp.product_name,
	SUM(fs.sales_amount) total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY	dp.product_id,
			dp.product_number,
			dp.product_name
ORDER BY total_sales DESC;
-- kalau mau hanya mengambil 5 tertinggi
SELECT * FROM 
(SELECT
	dp.product_id,
	dp.product_number,
	dp.product_name,
	SUM(fs.sales_amount) total_sales,
	RANK() OVER(ORDER BY SUM(fs.sales_amount) DESC) rank_products
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY	dp.product_id, dp.product_number, dp.product_name
)t
WHERE rank_products <= 5

-- which 5 products generate the worst revenue
-- bisa pakai top 5
SELECT TOP 5 -- lebih simple :)
	dp.product_id,
	dp.product_number,
	dp.product_name,
	SUM(fs.sales_amount) total_sales,
	RANK() OVER(ORDER BY SUM(fs.sales_amount) ASC) rank_products
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY	dp.product_id, dp.product_number, dp.product_name;

-- top 3 customers yang paling dikit order
SELECT TOP 3
	dc.customer_id,
	dc.first_name + ' '+ dc.last_name customer_name,
	COUNT(DISTINCT order_number) total_order,
	RANK() OVER(ORDER BY COUNT(DISTINCT order_number) ASC ) rank
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_id, dc.first_name + ' '+ dc.last_name

-- 3 terbanyak order
SELECT TOP 3
	dc.customer_id,
	dc.first_name + ' '+ dc.last_name customer_name,
	COUNT(DISTINCT order_number) total_order,
	RANK() OVER(ORDER BY COUNT(DISTINCT order_number) DESC ) RANK
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_id, dc.first_name + ' '+ dc.last_name