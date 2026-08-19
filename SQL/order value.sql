--ORDER VALUE
--
SELECT
    ROUND(SUM(price), 2) AS total_product_value,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_item_value,
    ROUND(AVG(price), 2) AS avg_item_price,
    ROUND(AVG(freight_value), 2) AS avg_freight
FROM order_item;


--
SELECT
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments;


--calculate payment value at the ORDER level

SELECT
    COUNT(*) AS orders_with_payment,
    ROUND(SUM(total_payment), 2) AS total_payment_value,
    ROUND(AVG(total_payment), 2) AS avg_order_payment
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM order_payments
    GROUP BY order_id
) x;

--Compare payment vs item value per order
SELECT
    ROUND(AVG(payment_total), 2) AS avg_payment_value,
    ROUND(AVG(item_total), 2) AS avg_item_value,
    ROUND(AVG(payment_total - item_total), 2) AS avg_difference
FROM (
    SELECT
        o.order_id,
        COALESCE(p.payment_total, 0) AS payment_total,
        COALESCE(i.item_total, 0) AS item_total
    FROM orders o

    LEFT JOIN (
        SELECT
            order_id,
            SUM(payment_value) AS payment_total
        FROM order_payments
        GROUP BY order_id
    ) p
        ON o.order_id = p.order_id

    LEFT JOIN (
        SELECT
            order_id,
            SUM(price + freight_value) AS item_total
        FROM order_item
        GROUP BY order_id
    ) i
        ON o.order_id = i.order_id
) x;


--
SELECT
    CASE
        WHEN ABS(payment_total - item_total) < 0.01
            THEN 'Match'
        WHEN payment_total > item_total
            THEN 'Payment > Items'
        ELSE 'Payment < Items'
    END AS reconciliation_status,
    COUNT(*) AS orders
FROM (
    SELECT
        o.order_id,
        COALESCE(p.payment_total, 0) AS payment_total,
        COALESCE(i.item_total, 0) AS item_total
    FROM orders o
    LEFT JOIN (
        SELECT
            order_id,
            SUM(payment_value) AS payment_total
        FROM order_payments
        GROUP BY order_id
    ) p ON o.order_id = p.order_id
    LEFT JOIN (
        SELECT
            order_id,
            SUM(price + freight_value) AS item_total
        FROM order_item
        GROUP BY order_id
    ) i ON o.order_id = i.order_id
) x
GROUP BY reconciliation_status
ORDER BY orders DESC;