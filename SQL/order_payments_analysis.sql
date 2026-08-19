
--order_payments
SELECT
    COUNT(*) AS total_payment_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT order_id) FILTER (
        WHERE order_id IS NOT NULL
    ) AS orders_with_payment
FROM order_payments;

--let's find the order without payment
SELECT
    o.order_id,
    o.order_status
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.order_id IS NULL;


--How many orders have multiple payment records?
SELECT
    payment_count,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM order_payments
    GROUP BY order_id
) x
GROUP BY payment_count
ORDER BY payment_count;

--How many orders have more than one payment record

SELECT
    COUNT(*) FILTER (WHERE payment_count = 1) AS single_payment_orders,
    COUNT(*) FILTER (WHERE payment_count > 1) AS multiple_payment_orders,
    COUNT(*) AS orders_with_payment
FROM (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM order_payments
    GROUP BY order_id
) x;


--let's investigate the 2,961 multiple-payment order
SELECT
    payment_count,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM order_payments
    GROUP BY order_id
) x
WHERE payment_count > 1
GROUP BY payment_count
ORDER BY payment_count;

--29 payment record
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments
WHERE order_id IN (
    SELECT order_id
    FROM order_payments
    GROUP BY order_id
    HAVING COUNT(*) = 29
)
ORDER BY order_id, payment_sequential;


--calculate its total payment value:

SELECT
    order_id,
    COUNT(*) AS payment_records,
    SUM(payment_value) AS total_payment_value
FROM order_payments
WHERE order_id = 'fa65dad1b0e818e3ccc5cb0e39231352'
GROUP BY order_id;


--
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp
FROM orders o
LEFT JOIN order_payments p
ON o.order_id = p.order_id
WHERE p.order_id IS NULL;

--Check the customer's record
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM customers
WHERE customer_id = '86dc2ffce2dfff336de2f386a786e574';

--
SELECT
    order_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM order_item
WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';