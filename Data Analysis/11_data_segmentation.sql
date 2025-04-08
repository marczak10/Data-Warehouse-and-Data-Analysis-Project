/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and
count how many products fall into each segment*/
WITH product_segments AS (
SELECT
	product_key,
	product_name,
	cost,
	CASE 
	WHEN cost < 100 THEN ' < 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 600 AND 1000 THEN '600-1000'
	ELSE '> 1000'
	END AS cost_range
FROM gold.dim_products
)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC; 

/*Group customers into three segments based on their spending behavior:
 - VIP: Customers with at least 12 months of history and spending more than €5,000.
 - Regular: Customers with at least 12 months of history but spending €5,000 or less.
 - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_groups AS (
SELECT 
	dc.customer_key,
	SUM(fs.sales_amount) AS total_sales,
	DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) AS lifespan,
	CASE 
		WHEN DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) >= 12 AND SUM(fs.sales_amount) > 5000 THEN 'VIP'
		WHEN DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) >= 12 AND SUM(fs.sales_amount) <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_group
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key
)

SELECT 
	customer_group,
	COUNT(customer_group) AS total_customers
FROM customer_groups
GROUP BY customer_group
ORDER BY COUNT(customer_group) DESC;