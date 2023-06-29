-- How many orders are delivered on time vs orders delivered with a delay?
SELECT
	COUNT(order_delivered_customer_date) as 'delayed'
FROM
	orders
WHERE
	order_delivered_customer_date > order_estimated_delivery_date
;
	

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT
	COUNT(order_delivered_customer_date) as 'delayed'
FROM
	orders
WHERE
	order_delivered_customer_date > order_estimated_delivery_date
;

-- What’s the average time between the order being placed and the product being delivered

SELECT
	order_status,
    AVG(datediff(order_delivered_customer_date, order_purchase_timestamp)) as difference
FROM
	orders
GROUP BY
	order_status
;



SELECT 
    CASE
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 0
        THEN
            'on_time'
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 24
        THEN
            'within_1_day'
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 48
        THEN
            'within_2_days'
        ELSE 'over_2_days_delay'
    END AS 'delivery_hours',
    CASE
        WHEN (product_length_cm * product_height_cm * product_height_cm / 1000000) < 0 THEN 'invalid'
        WHEN (product_length_cm * product_height_cm * product_height_cm / 1000000) < 0.5 THEN 'lowervolume<0,5'
        ELSE 'highervolume>0,5'
    END AS 'delivery_size',
    CASE
        WHEN (p.product_weight_g / 1000) <0 THEN 'invalid'
        WHEN (p.product_weight_g / 1000) < 2 THEN 'under2kg'
        ELSE 'over2kg'
    END AS 'delivery_weight_kg',
    COUNT(*)
FROM
    orders AS o
        LEFT JOIN
    order_items AS oi ON o.order_id = oi.order_id
        LEFT JOIN
    products AS p ON oi.product_id = p.product_id
GROUP BY 1,2,3
ORDER BY 1,2,3 DESC;


WITH category AS (
    SELECT
        product_category_name,
        CASE
            WHEN
                product_category_name_english LIKE 'au_%'
                OR product_category_name_english LIKE 'comp__%'
                OR product_category_name_english LIKE 'pc__%'
                OR product_category_name_english LIKE 'm%ic'
                OR product_category_name_english LIKE 'tele__%'
                OR product_category_name_english LIKE 'tab%'
                OR product_category_name_english LIKE 'wat%'
                OR product_category_name_english LIKE 'dvd%'
                OR product_category_name_english LIKE 'fix%'
                OR product_category_name_english LIKE 'ele%'
                OR product_category_name_english LIKE 'sec%'
                OR product_category_name_english LIKE 'sig%'
            THEN 'Apple_Tech'
            ELSE 'Others'
        END AS new_category
    FROM
        product_category_name_translation
),
category_counts AS (
    SELECT
        categories.new_category,
        COUNT(DISTINCT order_items.seller_id) AS total_sellers,
        COUNT(DISTINCT order_items.product_id) AS total_products,
        round(avg(order_items.price),2) as average_price
    FROM
        order_items
        JOIN products ON products.product_id = order_items.product_id
        JOIN category AS categories ON categories.product_category_name = products.product_category_name
    GROUP BY
        categories.new_category
)
SELECT
    new_category,
    total_sellers,
    total_products,
    ROUND((total_sellers / (SELECT COUNT(DISTINCT seller_id) FROM order_items)) * 100, 2) AS seller_percent,
    ROUND((total_products / (SELECT COUNT(DISTINCT product_id) FROM order_items)) * 100, 2) AS product_percent,
    average_price
    
FROM
    category_counts;
    
    -- ####################################################################
    
    SELECT 
    CASE
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 0
        THEN
            'on_time'
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 24
        THEN
            'within_1_day'
        WHEN
            TIMESTAMPDIFF(HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 48
        THEN
            'within_2_days'
        ELSE 'over_2_days_delay'
    END AS 'delivery_hours',
    CASE
        WHEN (product_length_cm * product_height_cm * product_height_cm / 1000000) < 0 THEN 'invalid'
        WHEN (product_length_cm * product_height_cm * product_height_cm / 1000000) < 0.5 THEN 'lowervolume<0,5'
        ELSE 'highervolume>0,5'
    END AS 'delivery_size',
    CASE
        WHEN (p.product_weight_g / 1000) <0 THEN 'invalid'
        WHEN (p.product_weight_g / 1000) < 2 THEN 'under2kg'
        ELSE 'over2kg'
    END AS 'delivery_weight_kg',
    COUNT(*)
FROM
    orders AS o
        LEFT JOIN
    order_items AS oi ON o.order_id = oi.order_id
        LEFT JOIN
    products AS p ON oi.product_id = p.product_id
GROUP BY 1,2,3
ORDER BY 1,2,3 DESC;
