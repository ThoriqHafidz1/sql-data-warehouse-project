/* 
============================
Performance Analysis:
	- comparing nilai saat ini ke sebuah nilai target
	- untuk mengukur keberhasilan dan melihat apakah performa sudah sesuai harapan atau masih perlu ditingkatkan.
============================
*/

-- task 1 --
-- analyze the yearly performance of products by comparing their sales,
-- to both the average sales performance of products & the previous sales

WITH yearly_product_sales AS 
(SELECT 
	YEAR(fs.order_date) year,
	dp.product_name,
	SUM(fs.sales_amount) yearly_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL
GROUP BY YEAR(fs.order_date), dp.product_name
--ORDER BY YEAR(fs.order_date)
)
SELECT
	year, 
	product_name,
	yearly_sales,
	AVG(yearly_sales) OVER(PARTITION BY product_name) average_sales,
	yearly_sales - AVG(yearly_sales) OVER(PARTITION BY product_name) AS diff_average,
	CASE
		WHEN yearly_sales - AVG(yearly_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
		WHEN yearly_sales - AVG(yearly_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
		ELSE 'Average'
	END AS status,
	LAG(yearly_sales) OVER(PARTITION BY product_name ORDER BY year) previous_sales,
	yearly_sales - LAG(yearly_sales) OVER(PARTITION BY product_name ORDER BY year) AS diff_sales,
	CASE
		WHEN yearly_sales - LAG(yearly_sales) OVER(PARTITION BY product_name ORDER BY year) > 0 THEN 'Increase'
		WHEN yearly_sales - LAG(yearly_sales) OVER(PARTITION BY product_name ORDER BY year) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END AS previous_sales_change
FROM yearly_product_sales
ORDER BY product_name, year
