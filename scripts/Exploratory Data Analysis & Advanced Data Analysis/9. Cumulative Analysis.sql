/* 
============================
Cumulative Analysis:
	mengumpulkan dan menjumlahkan data secara bertahap seiring berjalannya waktu.
	membantu untuk memahami apakah bisnis sedang berkembang atau menurun
============================
*/

-- task 
-- calculate the total sales per month & the running total of sales overtime
SELECT 
	t.*, 
	SUM(t.total_sales_by_month) OVER(ORDER BY t.year, t.month) running_total
FROM
	(SELECT 
		YEAR(order_date) year,
		MONTH(order_date) month,
		SUM(sales_amount) total_sales_by_month
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date), MONTH(order_date)
	-- ORDER BY YEAR(order_date),MONTH(order_date) -- tidak boleh di dalam subquery
	)t
	-- pakai datetrunc

SELECT 
	*,
	SUM(monthly_sales) OVER(ORDER BY month) monthly_running_total
FROM
(
	SELECT 
		DATETRUNC(MONTH,order_date) month,
		SUM(sales_amount) monthly_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
	-- ORDER BY DATETRUNC(MONTH,order_date)
)t
-- Running total by year
SELECT 
	*,
	SUM(monthly_sales) OVER(PARTITION BY month_date ORDER BY month_date) monthly_running_total
FROM
(
	SELECT 
		DATETRUNC(MONTH,order_date) month_date,
		SUM(sales_amount) monthly_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
	-- ORDER BY DATETRUNC(MONTH,order_date)
)t -- kalau dilihat hasilnya, setaiap awal tahun akan sama
----
-- running total by year
SELECT 
	*,
	SUM(monthly_sales) OVER(ORDER BY year_date) year_running_total
FROM
(
	SELECT 
		DATETRUNC(YEAR,order_date) year_date,
		SUM(sales_amount) monthly_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR,order_date)
	-- ORDER BY DATETRUNC(MONTH,order_date)
)t 

-- membuat moving avg price pertahun
SELECT 
	*,
	SUM(yearly_sales) OVER(ORDER BY year_date) year_running_total,
	AVG(monthly_avg_price) OVER(ORDER BY year_date) year_avg_price
FROM
(
	SELECT 
		DATETRUNC(YEAR,order_date) year_date,
		SUM(sales_amount) yearly_sales,
		AVG(price) monthly_avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR,order_date)
	-- ORDER BY DATETRUNC(MONTH,order_date)
)t