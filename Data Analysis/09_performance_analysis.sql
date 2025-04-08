/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */
WITH yearly_product_sales AS (
SELECT
	YEAR(fs.order_date) AS order_year,
	dp.product_name AS product_name,
	SUM(fs.sales_amount) AS current_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
WHERE YEAR(fs.order_date) IS NOT NULL
GROUP BY YEAR(fs.order_date), dp.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales, 
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above average'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below average'
		ELSE 'Even'
	END AS avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS diff_previous_year,
	CASE 
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year
