-- Calculating total sales amount

SELECT SUM(Amount) FROM amazon_sales;

-- Total orders

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM amazon_sales;

-- Total quantity sold
SELECT SUM(Qty) AS total_quantity
FROM amazon_sales;

-- 	PERFORMANCE ANALYSIS --

-- sales category
SELECT Category, SUM(Amount) AS total_sales
FROM amazon_sales
GROUP BY Category
ORDER BY total_sales DESC;

-- Top performing style

SELECT Style, SUM(Amount) AS total_sales
FROM amazon_sales
GROUP BY Style
ORDER BY total_sales DESC
LIMIT 5;

-- Sales Growth

SELECT DATE_FORMAT(Date, '%Y-%m') AS month,
       SUM(Amount) AS monthly_sales,
       LAG(SUM(Amount)) OVER (ORDER BY DATE_FORMAT(Date, '%Y-%m')) AS previous_month_sales,
       (SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY DATE_FORMAT(Date, '%Y-%m'))) / LAG(SUM(Amount)) OVER (ORDER BY DATE_FORMAT(Date, '%Y-%m')) * 100 AS growth_rate
FROM amazon_sales
GROUP BY month;


-- Average Order Value (AOV) Over TimeAverage Order Value (AOV) Over Time
SELECT 
    DATE_FORMAT(date, '%Y?%M') AS month,
    SUM(DISTINCT order_id) AS total_orders,
    SUM(Amount) AS total_sales,
    SUM(Amount) / COUNT(DISTINCT order_id)
FROM amazon_sales
GROUP BY month;

-- What percentage does each category contribute to total revenue?

SELECT Category, SUM(Amount) AS category_sales,
(SUM(Amount) / (SELECT SUM(Amount) FROM sales_table) * 100) AS sales_percentage
FROM sales_table
GROUP BY Category
ORDER BY category_sales DESC;

--  City & State Level Sales 

SELECT ship_city,ship_state,SUM(Amount) AS total_sales,
COUNT(DISTINCT order_id) AS total_orders
FROM amazon_sales
GROUP BY ship_city , ship_state
ORDER BY total_sales DESC;

-- High-Value Orders

WITH percentiles AS (SELECT Amount,PERCENT_RANK() OVER (ORDER BY Amount) AS percentile 
FROM sales_table)
SELECT *
FROM percentiles
WHERE percentile >= 0.95;













