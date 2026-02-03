--Sales Analysis
--Total Sales Revenue

SELECT 
    ROUND(SUM(p.price * od.quantity * (1 - od.discount_percent/100)), 2) AS total_sales
FROM order_details od
JOIN products p ON od.product_id = p.product_id;

--Monthly Sales Trend

SELECT 
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month,
    SUM(p.price * od.quantity) AS monthly_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY month
ORDER BY month;

--Customer Behavior Analysis
--Repeat Customers

SELECT 
customer_id,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

--Top Spending Customers

WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(p.price * od.quantity) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *,
RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM customer_spending;

--Profitability Analysis
--Product-wise Profit

SELECT 
p.product_name,
SUM((p.price - p.cost_price) * od.quantity) AS total_profit
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name;

--Loss-Making Products

SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM((p.price - p.cost_price) * od.quantity) AS profit
    FROM products p
    JOIN order_details od ON p.product_id = od.product_id
    GROUP BY p.product_name
) sub
WHERE profit < 0;

--Returns Analysis
--Return Rate

SELECT 
    ROUND(COUNT(r.return_id)::decimal / COUNT(o.order_id) * 100, 2) AS return_rate_percent
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id;

--Common Return Reasons

SELECT 
return_reason,
COUNT(*) AS total_returns
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;
