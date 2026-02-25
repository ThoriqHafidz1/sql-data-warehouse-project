/* 
============================
Exploratory Dimension:
	- untuk mengidentifikasi nilai unique (categori) pada setiap dimensi
	- untuk mengetahui kemungkinan data di-grupkan atau disegmentesaikan
============================
*/

-- task 1 --
-- explore all countries our customers come from

SELECT
	DISTINCT (country)
FROM gold.dim_customers;
--
SELECT 
	country,
	COUNT(*) total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY country;

-- task 2 -- 
-- explore all categories "The Major Divisions"
SELECT 
	DISTINCT(category) 
FROM gold.dim_products;
--
SELECT 
	DISTINCT(category), subcategory
FROM gold.dim_products;
--
SELECT 
	DISTINCT(category), subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;