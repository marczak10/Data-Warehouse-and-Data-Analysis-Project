/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
SELECT TOP 5
	dp.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.product_key, dp.product_name
ORDER BY total_revenue DESC;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	dp.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) ASC) AS rank_products
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.product_key, dp.product_name
ORDER BY total_revenue ASC;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 5
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_customers
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;


-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders,
	ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT order_number) ASC) AS rank_customers
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;