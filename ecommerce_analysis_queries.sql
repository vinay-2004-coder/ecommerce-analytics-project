-- Ecommerce Analysis SQL (Clean Version)

-- Daily Sales
SELECT order_date, SUM(sales) AS total_sales
FROM superstore
GROUP BY order_date
ORDER BY order_date;

-- Monthly Sales
SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
FROM superstore
GROUP BY month
ORDER BY month;

-- Top 5 Customers
SELECT customer_name, SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;

-- Sales by Region
SELECT region, SUM(sales) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Rank Customers within Region
SELECT region, customer_name,
       SUM(sales) AS total_sales,
       RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM superstore
GROUP BY region, customer_name;

-- Top 3 per Region
WITH ranked AS (
    SELECT region, customer_name,
           SUM(sales) AS total_sales,
           RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
    FROM superstore
    GROUP BY region, customer_name
)
SELECT * FROM ranked WHERE rank_in_region <= 3;

-- Running Total
SELECT order_date,
       SUM(sales) AS daily_sales,
       SUM(SUM(sales)) OVER (ORDER BY order_date) AS running_total
FROM superstore
GROUP BY order_date;

-- Previous Day Sales
SELECT order_date,
       SUM(sales) AS daily_sales,
       LAG(SUM(sales)) OVER (ORDER BY order_date) AS previous_day_sales
FROM superstore
GROUP BY order_date;

-- Day Difference
SELECT order_date,
       SUM(sales) AS daily_sales,
       SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_date) AS diff
FROM superstore
GROUP BY order_date;

-- Contribution %
SELECT customer_name,
       SUM(sales) AS total_sales,
       ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER (), 2) AS pct
FROM superstore
GROUP BY customer_name
ORDER BY total_sales DESC;
