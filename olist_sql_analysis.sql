-- =====================================================
-- E-COMMERCE SQL ANALYSIS PROJECT
-- Dataset: Olist E-commerce Dataset
-- Tool: PostgreSQL
-- =====================================================


-- Q1: Total Revenue
SELECT 
    SUM(price) AS total_revenue
FROM order_items;


-- Q2: Total Number of Orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- Q3: Total Number of Customers
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers;


-- Q4: Average Order Value
SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        order_id,
        SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) t;


-- Q5: Monthly Revenue Trend
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- Q6: Top 10 Customers by Revenue
SELECT 
    o.customer_id,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Q7: Top 5 States by Revenue
SELECT 
    c.customer_state,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;


-- Q8: Revenue by Product Category
SELECT 
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;


-- Q9: Average Items per Order
SELECT 
    AVG(item_count) AS average_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(order_item_id) AS item_count
    FROM order_items
    GROUP BY order_id
) t;


-- Q10: Orders per Month
SELECT 
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- Q11: Revenue per Customer
SELECT 
    o.customer_id,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY revenue DESC;


-- Q12: Revenue per Category
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;


-- Q13: Revenue per State
SELECT 
    c.customer_state,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC;


-- Q14: Rank Customers by Revenue
SELECT 
    o.customer_id,
    SUM(oi.price) AS revenue,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.customer_id;


-- Q15: Top 3 Customers per State
SELECT 
    customer_id,
    customer_state,
    revenue,
    revenue_rank
FROM (
    SELECT 
        c.customer_id,
        c.customer_state,
        SUM(oi.price) AS revenue,
        RANK() OVER (
            PARTITION BY c.customer_state 
            ORDER BY SUM(oi.price) DESC
        ) AS revenue_rank
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_state
) t
WHERE revenue_rank <= 3;


-- Q16: Running Total Revenue by Month
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS monthly_revenue,
    SUM(SUM(oi.price)) OVER (
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ) AS running_total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- Q17: Orders with Highest Value
SELECT 
    o.order_id,
    SUM(oi.price) AS order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_value DESC
LIMIT 10;


-- Q18: Highest Revenue Month
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;


-- Q19: Lowest Revenue Category
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue ASC
LIMIT 1;