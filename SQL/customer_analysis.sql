
-- customer table analysis


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

--finding the repeatd customers who ordered more than once
SELECT
    customer_unique_id,
    COUNT(*) AS order_count
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

--counting customers with repeated orders
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) x;

--
SELECT
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT customer_unique_id)
         FROM customers),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) x;

--How many orders does each actual customer have?

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC;

--summary
SELECT
    total_orders,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) x
GROUP BY total_orders
ORDER BY total_orders;

--the actual customer-level repeat rate and order contribution

SELECT
    COUNT(*) FILTER (WHERE total_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
    COUNT(*) AS total_customers,

    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_rate,

    SUM(total_orders) FILTER (WHERE total_orders = 1)
        AS orders_from_one_time_customers,

    SUM(total_orders) FILTER (WHERE total_orders > 1)
        AS orders_from_repeat_customers

FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) customer_orders;