/* 
============================
product Report
============================
Purpose:
	- report ini menyatukan data utama tentang metrik dan perilaku produk

Hihglights:
	1. mengumpulkan kolom penting produk
	2. Aggregasi product-level metrik :
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
CREATE VIEW gold.report_products AS
WITH base_query AS 
	(SELECT 
		fs.order_number,
		fs.customer_key,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dp.product_key,
		dp.product_number,
		dp.product_name,
		dp.category,
		dp.subcategory,
		dp.cost
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON fs.product_key = dp.product_key
	)

, product_aggregation AS
	(SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		MIN(order_date) first_order,
		MAX(order_date) last_order,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date))  lifespan,
		COUNT(DISTINCT order_number) total_order,
		COUNT(DISTINCT product_name) total_product,
		SUM(quantity) total_quantity,
		SUM(sales_amount) total_sales,
		ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) avg_selling_price
	FROM base_query
	GROUP BY product_key,
			 product_name,
			 category,
			 subcategory,
			 cost
	)

SELECT 
	product_key,
		product_name,
		category,
		subcategory,
		cost,
		first_order,
		last_order,
		lifespan,
		total_order,
		total_product,
		total_quantity,
		total_sales,
		CASE
			WHEN  total_sales > 50000 THEN 'High-Performer'
			WHEN total_sales >= 10000 THEN 'Mid-Range'
			ELSE 'Low-Performer'
		END AS product_segments,
		avg_selling_price,
		ROUND(AVG(CAST(total_sales AS FLOAT) / total_order),1) avg_order_revenue,
		ROUND(AVG(CAST(total_sales AS FLOAT) / lifespan),1) avg_monthly_spend
	FROM product_aggregation
	GROUP BY 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		first_order,
		last_order,
		lifespan,
		total_order,
		total_product,
		total_quantity,
		total_sales,
		avg_selling_price

		
/*
SELECT * FROM gold.report_products
ORDER BY total_sales DESC
*/