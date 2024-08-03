-- Запросы

-- Использующие реляционные и булевы операторы в предикатах. 
-- Вывести информацию о товарах, поставляемых 2 поставщиком, количество которых не больше 7.

SELECT product_id,
    product_name,
    amount,
    price,
    supplier_id
FROM product
WHERE amount <= 7 AND supplier_id = 2;

-- C использованием специальных операторов в условиях.
-- Вывести информацию о шоколадках, цена которых меньше 100.

SELECT product_id, product_name, amount, price
FROM product
WHERE price < (
    SELECT AVG(price) avg_price 
    FROM product) 
    AND product_name LIKE '%околад%';

-- C использованием групповых функций (где структура данных допускает их использование).
-- Общее количество товаров и их средняя цена.

SELECT SUM(amount) AS product_amount,
    ROUND(AVG(price), 2) AS avg_price
FROM product;

-- На вычислимое поле с форматированием результата.
-- Выводит информацию о том, какой процент каждый заказ составляет от общей суммы заказов.

SELECT buy_id,
    product_id,
    product_name,
    price,
    buy_product.amount, 
    ROUND(100*price*buy_product.amount/SUM(price*buy_product.amount) OVER(), 2) AS percent_of_sum_price, '%'
FROM buy_product 
LEFT JOIN product USING(product_id)
ORDER BY percent_of_sum_price DESC;

-- C использованием нескольких таблиц.
-- Вывод информации о пользователях и их заказах.

SELECT client_id,
    client_name,
    product_id,
    product_name,
    price
FROM buy
JOIN client USING(client_id) 
LEFT JOIN product ON product.product_id = buy.buy_id;

-- На соединение таблицы самой с собой.
-- Выводится информация о наборах состоящих из 3 и 2 категории с учётом скидки в 10%.

SELECT p1.product_name,
    p2.product_name,
    0.9*(p1.price+p2.price) AS "Цена комбо"
FROM product p1,
    product p2
WHERE p1.category_id = 3 AND p2.category_id = 2;

-- C использованием вложенных запросов.
-- Вывести товары, цены которых выше среднего, в порядке снижения стоимости.

SELECT product_id,
    product_name,
    price 
FROM product
WHERE price > (SELECT AVG(price) FROM product) 
ORDER BY price DESC;

-- На связанные подзапросы.
-- Вывести категории тех товаров, количество которых меньше 200 штук.

SELECT * 
FROM category 
WHERE 200 > (SELECT SUM(amount) FROM product WHERE product.category_id = category.category_id);

-- С использованием операторов EXIST, ANY, ALL, SOME.
-- Вывести имена тех клиентов, которые делали заказ.

SELECT client_id,
    client_name 
FROM client
WHERE EXISTS (SELECT client_id FROM buy WHERE buy.client_id = client.client_id);

-- С использованием оператора UNION.
-- Вывести товары, которые поставляют "Яшкино" или "Холдинг «Объединенные кондитеры»", или которые хорошо продаются (условно более 100 единиц товара).

SELECT product_id,
    product_name 
FROM product 
WHERE (supplier_id = 2 or supplier_id = 4)
UNION 
    SELECT product_id,
        product_name 
    FROM product 
    WHERE (product_id IN (
        SELECT product_id 
        FROM (SELECT product_id, SUM(amount) AS s FROM buy_product GROUP BY product_id) 
        WHERE s>100));

-- C командами обновления.
-- Обновить ассортимент продуктов в зависимости от продаж.

UPDATE product p 
SET amount = p.amount - new_base.sum 
FROM (
    SELECT product_id, SUM(amount) 
    FROM buy_product 
    GROUP BY product_id) AS new_base
WHERE (p.product_id = new_base.product_id);

-- Средняя цена и сумма товаров по категориям

SELECT category_id,
    SUM(amount) AS product_amount, 
    ROUND(AVG(price), 2) AS avg_price
FROM product
GROUP BY category_id
ORDER BY category_id ASC;

-- Наиболее популярные товары в Июне (6 месяце), цена которых ниже средней

SELECT product_id,
    product_name,
    SUM(amount) AS product_count,
    price
FROM (SELECT product_id, product_name, buy_product.amount, price
		FROM buy_product
		JOIN product USING(product_id)
	  	JOIN buy_step USING(buy_id)
		WHERE price < (SELECT AVG(price) AS avg_price FROM product) AND DATE_PART('month', step_date_end) = 6)
GROUP BY product_id, product_name, price
ORDER BY product_count DESC

