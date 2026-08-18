
--funnel analysis 
-- finding grain of data

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    SUM(order_count) AS total_orders
FROM (
    SELECT
        order_status,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY order_status
) x;

--grain is 
-- 1 row = 1 order 


--DATA RANGE
SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- TIMESTAMP COMPLETENESS
SELECT
    COUNT(*) AS total_orders,
    COUNT(order_approved_at) AS approved_orders,
    COUNT(order_delivered_carrier_date) AS shipped_orders,
    COUNT(order_delivered_customer_date) AS delivered_orders,
    COUNT(order_estimated_delivery_date) AS orders_with_estimated_date
FROM orders;


SELECT
    order_id,
    order_status,
    order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;



  SELECT
    COUNT(*) AS delivered_status_orders,
    COUNT(order_delivered_customer_date) AS delivered_with_timestamp,
    COUNT(*) - COUNT(order_delivered_customer_date) AS delivered_without_timestamp
FROM orders
WHERE order_status = 'delivered';