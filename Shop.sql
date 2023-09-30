\! chcp 1251

DROP DATABASE IF EXISTS shop;

CREATE DATABASE shop;

\connect shop

CREATE TABLE city 
(
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(30),
    city_days_delivery INT NOT NULL
);

CREATE TABLE client
(
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(30),
    client_birthday DATE,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id)
        REFERENCES city (city_id)
        ON DELETE NO ACTION
);

CREATE TABLE store
(
    store_id SERIAL PRIMARY KEY,
    city_id INT NOT NULL,
    store_adress VARCHAR(100),
    FOREIGN KEY (city_id)
        REFERENCES city (city_id)
        ON DELETE NO ACTION
);

CREATE TABLE supplier
(
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(30)
);

CREATE TABLE category
(
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(30)
);

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(500),
    product_rate DECIMAL(2, 1) DEFAULT 0,
    amount INT NOT NULL,
    store_id INT NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE CASCADE,
    FOREIGN KEY (supplier_id)
        REFERENCES supplier (supplier_id)
        ON DELETE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES store (store_id)
);

CREATE TABLE buy
(
    buy_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id)
        REFERENCES client (client_id)
        ON DELETE CASCADE
);

CREATE TABLE buy_product
(
    buy_product_id SERIAL PRIMARY KEY,
    buy_id INT NOT NULL,
    product_id INT NOT NULL,
    buy_product_rate DECIMAL(2, 1) DEFAULT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (buy_id)
        REFERENCES buy (buy_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE CASCADE
);

CREATE TABLE step
(
    step_id SERIAL PRIMARY KEY,
    step_name VARCHAR(30)
);

CREATE TABLE buy_step
(
    buy_step_id SERIAL PRIMARY KEY,
    buy_id INT NOT NULL,
    step_id INT NOT NULL,
    step_date_beg DATE,
    step_date_end DATE DEFAULT NULL,
    FOREIGN KEY (buy_id)
        REFERENCES buy (buy_id)
        ON DELETE CASCADE,
    FOREIGN KEY (step_id)
        REFERENCES step (step_id)
        ON DELETE CASCADE
);


INSERT INTO city (city_name, city_days_delivery) VALUES
    ('Москва', 14),
    ('Казань', 30),
    ('Уфа', 60),
    ('Ижевск', 60),
    ('Санкт-Петербург', 30);

INSERT INTO store (city_id, store_adress) VALUES
    (1, 'Дубосековская, 5');

INSERT INTO client VALUES
    (DEFAULT, 'Ашот', '2000-10-05', 1),
    (DEFAULT, 'Billy', '1997-07-06' , 3),
    (DEFAULT, 'Паштет', '1999-12-31', 2),
    (DEFAULT, 'Van', '2003-07-07', 4),
    (DEFAULT, 'Джонни', '1995-05-06', 5);

INSERT INTO category (category_name) VALUES
    ('Вафли'),
    ('Мармелад'),
    ('Плиточный шоколад'),
    ('Конфеты');

INSERT INTO supplier (supplier_name) VALUES
    ('Коломенское'),
    ('Яшкино'),
    ('Choco Pie Company');

-- Добавить еще 8 товаров
INSERT INTO product (product_name, amount, store_id, category_id, supplier_id) VALUES
    ('Вафли шоколадные', 14, 1, 1, 2);

INSERT INTO step (step_name) VALUES
    ('Оплата'),
    ('Упаковка'),
    ('Доставка'),
    ('Возврат');

INSERT INTO buy (client_id) VALUES
    (1),
    (2),
    (3),
    (4),
    (3);

-- Каждый заказ включает только один тип товара => добавить 4 товара, которые заказаны
INSERT INTO buy_product (buy_id, product_id, buy_product_rate, amount) VALUES
    (1, 1, DEFAULT, 3);

/*
    Добавить для заказанных товаров (4) шаг, на котором они находятся 
    Если шаг, на котором находится товар, еще не завершен то в step_date_end ставить NULL
    Время доставки - шага 3 - не должно сильно отличаться от кол-ва дней в таблице city
*/
INSERT INTO buy_step (buy_id, step_id, step_date_beg, step_date_end) VALUES
    (1, 1, '2023-06-06', '2023-06-07'),
    (1, 2, '2023-06-07', '2023-06-09'),
    (1, 3, '2023-06-09', '2023-06-20');