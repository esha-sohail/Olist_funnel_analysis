
--next major funnel stage: ⭐ REVIEWS
--Of the delivered orders, how many received a customer review?

SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS review_rate
FROM orders o
LEFT JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';

--Next analysis: Review score distribution
--
SELECT
    review_score,
    COUNT(DISTINCT order_id) AS reviewed_orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0
        / SUM(COUNT(DISTINCT order_id)) OVER (),
        2
    ) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

--calculate the average score

SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews;

--Are late deliveries driving bad reviews?
--let's establish delivery performance.

SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
    END AS delivery_performance,
    COUNT(*) AS delivered_orders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
    END
ORDER BY delivered_orders DESC;

--Does lateness affect review scores?

SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
    END AS delivery_performance,


    COUNT(DISTINCT r.order_id) AS reviewed_orders,


    ROUND(AVG(r.review_score), 2) AS avg_review_score


FROM orders o


JOIN order_reviews r
    ON o.order_id = r.order_id


WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL


GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
    END


ORDER BY avg_review_score DESC;

--How much more likely is a late order to receive a 1-star review

SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
    END AS delivery_performance,

    COUNT(DISTINCT r.order_id) AS reviewed_orders,

    COUNT(DISTINCT CASE
        WHEN r.review_score = 1 THEN r.order_id
    END) AS one_star_reviews,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.review_score = 1 THEN r.order_id
        END) * 100.0
        / COUNT(DISTINCT r.order_id),
        2
    ) AS one_star_rate

FROM orders o

JOIN order_reviews r
    ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
    END

ORDER BY one_star_rate DESC;


--HOW late orders affect ratings


SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_performance,

    ROUND(
        AVG(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN EXTRACT(
                    EPOCH FROM (
                        o.order_delivered_customer_date
                        - o.order_estimated_delivery_date
                    )
                ) / 86400
            END
        )::numeric,
        2
    ) AS avg_days_late,

    MAX(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    - o.order_estimated_delivery_date
                )
            ) / 86400
        END
    ) AS max_days_late

FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END;