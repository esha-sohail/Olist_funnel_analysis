
--actual funnel analysis
--Order → Approved → Paid → Shipped → Delivered → Reviewed

SELECT
    COUNT(*) AS total_orders,
    COUNT(order_approved_at) AS approved,
    COUNT(order_delivered_carrier_date) AS shipped_to_carrier,
    COUNT(order_delivered_customer_date) AS delivered_to_customer
FROM orders;


--let's measure the time between stages ⏱️
SELECT
    ROUND(
        AVG(EXTRACT(EPOCH FROM
            (order_approved_at - order_purchase_timestamp)
        ) / 3600)::numeric,
        2
    ) AS avg_hours_purchase_to_approval,


    ROUND(
        AVG(EXTRACT(EPOCH FROM
            (order_delivered_carrier_date - order_approved_at)
        ) / 3600)::numeric,
        2
    ) AS avg_hours_approval_to_shipping,


    ROUND(
        AVG(EXTRACT(EPOCH FROM
            (order_delivered_customer_date - order_delivered_carrier_date)
        ) / 3600)::numeric,
        2
    ) AS avg_hours_shipping_to_delivery
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;

  -- what happened to other orders
  SELECT
    order_status,
    COUNT(*) AS orders
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NULL
GROUP BY order_status
ORDER BY orders DESC;