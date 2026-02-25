/* 
============================
Customer Report
============================
Purpose:
	- report ini menyatukan data utama tentang metrik dan perilaku pelanggan

Hihglights:
	1. mengumpulkan kolom penting seperti nama, umur dan detail transaksi
	2. Aggregasi customer-level metrik :
		- total order
		- total sales
		- total quantity
		- total product
		- lifespan (in months)
	3. Segmentasi customers ke categori (VIP, Regular, New) & umur
	4. Menghitung KPIs yang bernilai:
		- recency (bulan terakhir order)
		- average order value
		- average monthly spend
============================
*/

-- 1. mengumpulkan kolom penting seperti nama, umur dan detail transaksi

CREATE VIEW gold.report_customers AS
WITH base_query AS
	/*
	====================================================
	Base Query --> Retrieve core columns from tables
	====================================================
	*/
	(SELECT 
		fs.order_number,
		fs.product_key,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dc.customer_key,
		dc.customer_number,
		CONCAT(dc.first_name, ' ',dc.last_name) customer_name,
		DATEDIFF(year, bitrthdate, GETDATE()) age,
		country
	FROM gold.dim_customers dc
	LEFT JOIN gold.fact_sales fs
	ON dc.customer_key = fs.customer_key
	WHERE order_date IS NOT NULL
	)

, customer_aggregation AS 
	(SELECT 
		customer_key, 
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_order,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key, 
			 customer_name,
			 age
	)

SELECT 
	customer_key, 
	customer_name,
	age,
	CASE
		WHEN age > 50 THEN 'Above 50'
		WHEN age BETWEEN 41 AND 50 THEN '41 - 50'
		WHEN age BETWEEN 31 AND 40 THEN '31 - 40' 
		WHEN age BETWEEN 21 AND 30 THEN '21 - 30'
		ELSE 'Under 20'
	END age_segments,
	CASE 
		WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segments,
	DATEDIFF(MONTH, last_order, GETDATE()) AS recency,
	CASE 
		WHEN total_sales = 0 THEN 0 
		ELSE total_sales / total_order 
	END AS avg_order_value,
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan 
	END AS avg_monthly_spend,
	total_order,
	total_products,
	total_sales,
	total_quantity
FROM customer_aggregation

/*
================ testing view ==========================
SELECT 
	age_segments,
	SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY age_segments
ORDER BY total_sales DESC
========================================================
*/