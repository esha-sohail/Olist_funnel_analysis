--order item grain 

SELECT
    COUNT(*) AS total_item_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM order_item;

--
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_item oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;


--order size
--How many items does an order typically contain?
SELECT
    item_count,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM order_item
    GROUP BY order_id
) x
GROUP BY item_count
ORDER BY item_count;


--
SELECT
    COUNT(*) AS orders_with_items,
    SUM(item_count) AS total_item_rows,
    ROUND(AVG(item_count), 2) AS avg_items_per_order,
    MIN(item_count) AS min_items,
    MAX(item_count) AS max_items
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM order_item
    GROUP BY order_id
) x;
