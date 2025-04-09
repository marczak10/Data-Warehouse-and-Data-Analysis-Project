/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
WITH category_sales AS (
SELECT
	category,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY category
)

SELECT	
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,	
	CONCAT(ROUND(CAST(total_sales AS FLOAT) / (SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_overall_sales
FROM category_sales
ORDER BY total_sales DESC