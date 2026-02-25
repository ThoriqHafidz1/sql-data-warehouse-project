/* 
============================
Part to Whole Analysis:
	--> analisa bagaimana satu bagian dicompare dengan keseluruhan
	- untuk memahami kategori mana yang paling berimpact dalam bisnis
============================
*/

-- TASK 1 --
-- which categories contibute the most to overall sales ?

SELECT 
*,
SUM(total_sales) OVER() AS overall_sales,
ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER())*100,2) percentage_of_totals
FROM
	(SELECT 
		dp.category,
		SUM(fs.sales_amount)total_sales
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON fs.product_key = dp.product_key
	GROUP BY dp.category
	)t
ORDER BY percentage_of_totals DESC
