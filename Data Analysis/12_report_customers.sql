/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics: 
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

-- =============================================================================
-- 1) Base Query: Retrieves core columns from tables
-- =============================================================================
WITH base_query AS (
SELECT 
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount, 
	fs.quantity,
	dc.customer_key,
	dc.customer_number,
	dc.first_name,
	dc.last_name,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	DATEDIFF(YEAR, dc.birthdate, GETDATE()) AS age
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
WHERE order_date IS NOT NULL  -- only consider valid sales dates
)

-- =============================================================================
-- 2) Customer Aggregations: Summarizes key metrics at the customer level
-- =============================================================================
, customer_aggregation AS (
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, age
)

-- =============================================================================
-- Final Output: Segments, Age Groups, KPIs
-- =============================================================================
-- - Age Group Buckets
-- - Customer Segments: VIP, Regular, New
-- - Metrics:
--     - Recency
--     - Average Order Value (AOV)
--     - Average Monthly Spend
-- =============================================================================
SELECT 
	customer_key, 
	customer_number, 
	customer_name, 
	age,
	CASE 
		 WHEN age < 20 THEN '< 20'
		 WHEN age between 20 and 29 THEN '20-29'
		 WHEN age between 30 and 39 THEN '30-39'
		 WHEN age between 40 and 49 THEN '40-49'
		 ELSE '>= 50'
	END AS age_group,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	lifespan,
	-- Compuate average order value (AVO)
	CASE 
		WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	-- Compuate average monthly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM customer_aggregation
