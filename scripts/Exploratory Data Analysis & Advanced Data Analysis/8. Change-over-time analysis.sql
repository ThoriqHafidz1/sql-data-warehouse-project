/* 
============================
Analysis Change Over Time:
	adalah bagaimana measure(indikator) berubah seiring waktu
	- membantu melihat pola perubahan jangka panjang dan pola berulang secara periodik
============================
*/

-- task 1 --
-- analyze sales performance over time
SELECT -- by day 
	order_date,
	SUM(sales_amount) total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date ASC ;
--
SELECT -- by Year
	YEAR(order_date) YEAR,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date) ASC ;

SELECT -- by MONTH
	MONTH(order_date) month,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date) ASC ;

SELECT -- combining month & year
	YEAR(order_date) year,
	MONTH(order_date) month,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date) ASC ;
--
SELECT -- bisa pakai datetrunc -- ini hasil nilainya akan tetap date
	DATETRUNC(MONTH, order_date) date,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date) ASC;
--
SELECT -- bisa pakai format - tapi hasil nilainya akan string
	FORMAT(order_date, 'yyyy-MMM') date,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM') ASC;


