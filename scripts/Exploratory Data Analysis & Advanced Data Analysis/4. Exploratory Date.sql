/* 
============================
Exploratory Tanggal:
	- untuk mengidentifikasi tanggal awal dan tanggal akhir
	- untuk mengetahui lingkup & rentang waktu (timespan) data
============================
*/

-- task 1 
-- find the date of the first & the last order
SELECT 
	 MIN(order_date) AS first_order_date,
	 MAX(order_date) AS last_order_date
FROM gold.fact_sales

-- task 2
-- 1. how many years of sales are available
SELECT
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS total_year,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS total_month,
	DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS total_day
FROM gold.fact_sales
--
SELECT
	DISTINCT(DATETRUNC(YEAR, order_date))
FROM gold.fact_sales
ORDER BY DATETRUNC(YEAR, order_date);
--
WITH CTE AS (
SELECT
	DISTINCT(DATENAME(YEAR, order_date)) year
FROM gold.fact_sales
-- ORDER BY DATENAME(YEAR, order_date) --> kalau pakai CTE tidak bisa ORDER BY di dalam CTE harus di luar. tapi kalau tanpa CTE bisa
)
SELECT 
	*
FROM CTE
WHERE year IS NOT NULL
ORDER BY year;

--2. find the youngest & the older customers
SELECT 
	MAX(bitrthdate) oldest_birthdate,
	MAX(DATEDIFF(YEAR, bitrthdate, GETDATE())) oldest_customer,
	MIN(bitrthdate) youngest_birthdate,
	MIN(DATEDIFF(YEAR, bitrthdate, GETDATE())) youngest_customer
FROM gold.dim_customers
-- umur termuda
SELECT * FROM 
(SELECT
	customer_id,
	first_name,
	bitrthdate,
	DATEDIFF(YEAR,bitrthdate, GETDATE()) umur,
	ROW_NUMBER() OVER(ORDER BY bitrthdate DESC) rank
FROM gold.dim_customers)t
WHERE rank = 1
-- umur tertua
SELECT * FROM 
(SELECT
	customer_id,
	first_name,
	bitrthdate,
	DATEDIFF(YEAR,bitrthdate, GETDATE()) umur,
	ROW_NUMBER() OVER(ORDER BY bitrthdate ASC) rank
FROM gold.dim_customers
WHERE bitrthdate IS NOT NULL)t
WHERE rank = 1