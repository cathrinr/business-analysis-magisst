-- How many months of data are included in the magist database?
SELECT
	TIMESTAMPDIFF(month, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) as 'difference'
FROM
	orders
;

-- How many sellers are there?

SELECT
	COUNT(seller_id)
FROM
	sellers
;

-- How many Tech sellers are there?

SELECT
	COUNT(DISTINCT a.seller_id)
FROM
	sellers a
LEFT JOIN order_items b
ON
	a.seller_id = b.seller_id
LEFT JOIN
	products c
ON
	b.product_id = c.product_id
WHERE 
	 c.product_category_name IN (
                'eletronicos',
                'audio',
                'consoles_games',
                'informatica_acessorios',
                'musica',
                'pc_gamer',
                'pcs',
                'tablets_impressao_imagem',
                'telefonia',
                'telefonia_fixa'
            )
;




-- What percentage of overall sellers are Tech sellers?

	SELECT
		COUNT(DISTINCT a.seller_id) as 'tech sellers'		
	FROM
		sellers a
	LEFT JOIN order_items b
	ON
		a.seller_id = b.seller_id
	LEFT JOIN
		products c
	ON
		b.product_id = c.product_id
	WHERE 
		 c.product_category_name IN (
					'eletronicos',
					'audio',
					'consoles_games',
					'informatica_acessorios',
					'musica',
					'pc_gamer',
					'pcs',
					'tablets_impressao_imagem',
					'telefonia',
					'telefonia_fixa'
				)
;


-- What is the total amount earned by all sellers? 
SELECT 
	ROUND(SUM(price), 2) as 'total earnings'
FROM
	order_items
;

-- What is the total amount earned by all Tech sellers?

SELECT 
	ROUND(SUM(price), 2) as 'total earnings'
FROM
	order_items a
LEFT JOIN products b
ON
	a.product_id = b.product_id	
WHERE 
	 product_category_name IN (
                'eletronicos',
                'audio',
                'consoles_games',
                'informatica_acessorios',
                'musica',
                'pc_gamer',
                'pcs',
                'tablets_impressao_imagem',
                'telefonia',
                'telefonia_fixa'
            )
;

-- Can you work out the average monthly income of all sellers? 
-- Use price

SELECT
	ROUND(SUM(price)*100 / COUNT(price),2) as 'average income',
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
	order_items a
LEFT JOIN orders b
ON a.order_id = b.order_id
GROUP BY 
    year_, 
    month_
ORDER BY 
	year_ , month_
;

SELECT
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    ROUND(SUM(price)/25, 2) as 'monthly income'
FROM
	order_items a
LEFT JOIN orders b
ON a.order_id = b.order_id
;
-- Can you work out the average monthly income of Tech sellers?

SELECT
	ROUND(SUM(price) / COUNT(price),2) as 'average income',
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
	order_items a
LEFT JOIN orders b
ON a.order_id = b.order_id
LEFT JOIN
	products c
ON
	a.product_id = c.product_id
WHERE 
	 c.product_category_name IN (
                'eletronicos',
                'audio',
                'consoles_games',
                'informatica_acessorios',
                'musica',
                'pc_gamer',
                'pcs',
                'tablets_impressao_imagem',
                'telefonia',
                'telefonia_fixa'
            )
GROUP BY 
    year_, 
    month_
ORDER BY 
	year_ , month_
;


-- How many products have not been sold?

SELECT
	COUNT(a.product_id) 
FROM
	products a
LEFT JOIN order_items b
	ON a.product_id = b.product_id
WHERE
	a.product_id != b.product_id
;
	
-- HOw many product are there in the relevant tech categories that cost more than 500€?
SELECT
	COUNT(a.product_id)
FROM
	order_items a
LEFT JOIN orders b
ON a.order_id = b.order_id
LEFT JOIN
	products c
ON
	a.product_id = c.product_id
WHERE 
	price > 500
AND
	 c.product_category_name IN (
                'eletronicos',
                'audio',
                'consoles_games',
                'informatica_acessorios',
                'musica',
                'pc_gamer',
                'pcs',
                'tablets_impressao_imagem',
                'telefonia',
                'telefonia_fixa'
            )
;
