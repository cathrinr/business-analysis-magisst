   --  What categories of tech products does Magist have?
   SELECT 
	'eletronicos' ,
    'audio',
	'consoles_games',
	'informatica_acessorios',
	'musica',
	'pc_gamer',
	'pcs',
	'tablets_impressao_imagem',
	'telefonia',
	'telefonia_fixa'
FROM
	products
;
	
   
    -- How many products of these tech categories have been sold (within the time window of the database snapshot)? 
    
    SELECT
		COUNT(b.product_id),
        a.product_category_name
	FROM 
		products a
	LEFT JOIN order_items b ON a.product_id = b.product_id
    WHERE product_category_name IN('eletronicos' ,
    'audio',
	'consoles_games',
	'informatica_acessorios',
	'musica',
	'pc_gamer',
	'pcs',
	'tablets_impressao_imagem',
	'telefonia',
	'telefonia_fixa')
    GROUP BY 
		a.product_category_name
		;
    
		
    
    
   -- HOw many product does each tech category have?
   
   SELECT
		COUNT(product_id),
        product_category_name
	FROM
		products
	WHERE product_category_name IN('eletronicos' ,
    'audio',
	'consoles_games',
	'informatica_acessorios',
	'musica',
	'pc_gamer',
	'pcs',
	'tablets_impressao_imagem',
	'telefonia',
	'telefonia_fixa')
    GROUP BY
		product_category_name
    ;
    
    
    
    
    -- What percentage does that represent from the overall number of products sold?
    
    
SELECT
    COUNT(b.product_id),
    a.product_category_name,
    (COUNT(b.product_id) * 100) / total_count AS 'percentage'
FROM
    products a
LEFT JOIN
    order_items b ON a.product_id = b.product_id
JOIN
    (SELECT COUNT(product_id) AS total_count FROM products) AS c
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
GROUP BY
    a.product_category_name, total_count;

   
   -- What’s the average price of the products being sold?
		-- per (TECH) category 
    SELECT 
		ROUND(AVG(a.price), 2) as 'average price',
        b.product_category_name as 'category name'
	FROM
		order_items a
	LEFT JOIN products b ON a.product_id = b.product_id
    WHERE product_category_name IN('eletronicos' ,
    'audio',
	'consoles_games',
	'informatica_acessorios',
	'musica',
	'pc_gamer',
	'pcs',
	'tablets_impressao_imagem',
	'telefonia',
	'telefonia_fixa')
	GROUP BY 
		product_category_name
	;
    
    -- Are expensive tech products popular? *
    
SELECT
    price_category,
    COUNT(*) AS count_by_price_category,
    product_category_name
FROM
    (
        SELECT
            a.order_id,
            a.product_id,
            a.price,
            b.product_category_name,
            CASE
                WHEN a.price > 500 THEN 'Expensive'
                ELSE 'Cheap'
            END AS price_category
        FROM
            order_items a
        LEFT JOIN
            products b ON a.product_id = b.product_id
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
    ) AS subquery
GROUP BY
    price_category, product_category_name;
    
    