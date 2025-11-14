create database P1005_Ecommerce;
use P1005_Ecommerce;
select * from olist_customers_dataset;
select * from olist_geolocation_Dataset;
select * from olist_order_items_Dataset;
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_sellers_dataset;
select * from product_category_name_translati;

----------------------------------------------------------------------------------------------------
# KPI-1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics.
----------------------------------------------------------------------------------------------------
SELECT
    CASE
        WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(op.payment_value) AS total_payment_value
FROM
    olist_orders_dataset o
JOIN
    olist_order_payments_dataset op ON o.order_id = op.order_id
GROUP BY
    day_type;


----------------------------------------------------------------------------------------------------
# KPI-2 Number of Orders with review score 5 and payment type as credit card.
----------------------------------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT o.order_id) AS five_star_credit_card_orders
FROM
    olist_orders_dataset o
JOIN
    olist_order_payments_dataset op ON o.order_id = op.order_id
JOIN
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
    r.review_score = 5 AND op.payment_type = 'credit_card';


----------------------------------------------------------------------------------------------------
# KPI-3 Average number of days taken for order_delivered_customer_date for pet_shop.
----------------------------------------------------------------------------------------------------
SELECT
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM
    olist_orders_dataset o
JOIN
    olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN
    olist_products_dataset p ON oi.product_id = p.product_id
JOIN
    olist_product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE
    t.product_category_name_english = 'pet_shop' AND o.order_delivered_customer_date IS NOT NULL;


----------------------------------------------------------------------------------------------------
# KPI 4 Average price and payment values from customers of sao paulo.
----------------------------------------------------------------------------------------------------
SELECT
    AVG(oi.price) AS average_product_price,
    AVG(op.payment_value) AS average_payment_value
FROM
    olist_orders_dataset o
JOIN
    olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN
    olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN
    olist_order_payments_dataset op ON o.order_id = op.order_id
WHERE
    c.customer_city = 'sao paulo';
    

----------------------------------------------------------------------------------------------------
# KPI 5 Relationship between shipping days (order_delivered_customer_date — order_purchase_timestamp) Vs review scores.
----------------------------------------------------------------------------------------------------
SELECT
    r.review_score,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_shipping_days
FROM
    olist_orders_dataset o
JOIN
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    r.review_score
ORDER BY
    r.review_score;
----------------------------------------------------------------------------------------------------