CREATE TABLE city 
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    days_delivery INT NOT NULL
);

CREATE TABLE client
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    birthday DATE,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id)
        REFERENCES city (id)
        ON DELETE NO ACTION
);


CREATE TABLE supplier
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE category
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    slug VARCHAR(100) DEFAULT NULL
);

CREATE TABLE product
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(500),
    slug VARCHAR(100),
    image VARCHAR(100) DEFAULT NULL, 
    price DECIMAL NOT NULL,
    amount INT NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    available BOOLEAN DEFAULT true,
    product_rate DECIMAL(2, 2) DEFAULT 0,
    FOREIGN KEY (category_id)
        REFERENCES category (id)
        ON DELETE CASCADE,
    FOREIGN KEY (supplier_id)
        REFERENCES supplier (id)
        ON DELETE CASCADE
);

CREATE TABLE buy
(
    id SERIAL PRIMARY KEY,
    FIO VARCHAR(500),
    email VARCHAR(100),
    adress VARCHAR(100),
    postal_code VARCHAR(100)
);

CREATE TABLE buy_product
(
    id SERIAL PRIMARY KEY,
    price DECIMAL NOT NULL,
    quantity INT NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_rate DECIMAL(2, 2) DEFAULT NULL,
    FOREIGN KEY (order_id)
        REFERENCES buy (id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES product (id)
        ON DELETE CASCADE
);

CREATE TABLE step
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30)
);

CREATE TABLE buy_step
(
    id SERIAL PRIMARY KEY,
    buy_id INT NOT NULL,
    step_id INT NOT NULL,
    step_date_beg DATE,
    step_date_end DATE DEFAULT NULL,
    FOREIGN KEY (buy_id)
        REFERENCES buy (id)
        ON DELETE CASCADE,
    FOREIGN KEY (step_id)
        REFERENCES step (id)
        ON DELETE CASCADE
);


INSERT INTO city (name, days_delivery) VALUES
    ('Москва', 14),
    ('Казань', 30),
    ('Уфа', 60),
    ('Ижевск', 60),
    ('Санкт-Петербург', 30);

INSERT INTO category (name) VALUES
    ('Вафли'),
    ('Мармелад'),
    ('Плиточный шоколад'),
    ('Конфеты'),
    ('Лакрица'),
    ('Печенье');

INSERT INTO supplier (name) VALUES
    ('Черноголовка'),
    ('Яшкино'),
    ('Babyfox'),
    ('Холдинг «Объединенные кондитеры»'),
    ('MARS Wrigley'),
    ('Мармеладыч'),
    ('TONDI');

INSERT INTO product (name, amount, price, category_id, supplier_id) VALUES
    ('Конфеты со вкусом Баббл гам', 40, 49.99, 4, 1),
    ('Шоколад молочный «Cherry Cola»', 14, 109.99, 3, 1),
    ('Конфеты Одуванчик', 18, 399.89, 4, 1),
    ('Вафли «Голландские», с карамельной начинкой', 33, 89.90, 1, 2),
    ('Шоколад молочный с крекером', 7, 44.5, 3, 2),
    ('Вафельные трубочки «Со вкусом сгущённого молока»', 12, 67.79, 1, 2),
    ('Мармелад жевательный', 30, 34.6, 2, 3),
    ('Конфеты mini с фундуком', 70, 450, 4, 3),
    ('Конфеты Creamy', 42, 340, 4, 3),
    ('Конфеты Сибирский сувенир', 39, 600, 4, 4),
    ('Мармелад Сладкая карусель', 21, 65, 2, 4),
    ('Молочный шоколад Аленка', 23, 70, 3, 4),
    ('Milky Way Minis', 87, 620, 4, 5),
    ('Коркунов горький шоколад', 60, 110, 3, 5),
    ('Ирис Золотой ключик', 10, 152, 4, 4),
    ('Сливочная помадка', 33, 154, 4, 4),
    ('Шоколад Вдохновение с миндалем', 28, 204, 3, 4),
    ('Конфеты вафельные Bueno', 32, 80, 1, 3),
    ('Батончик вафельный Babyfox Roxy', 25, 10, 1, 3),
    ('Ирис Сливочный', 21, 197, 4, 2),
    ('Dove молочный шоколад с изюмом', 20, 92, 3, 5),
    ('Мармелад кислый ассорти', 120, 800, 2, 6),
    ('Лакрица ассорти', 210, 1000, 5, 6),
    ('Тропический червяк Кузя', 7, 3560, 2, 6),
    ('Печенье-сэндвич с шоколадно-сливочным вкусом', 187, 60, 6, 7),
    ('Печенье-сэндвич с клубнично-сливочным вкусом', 212, 65, 6, 7),
    ('Эклеры сливочные', 103, 120, 6, 7);

INSERT INTO step (name) VALUES
    ('Оплата'),
    ('Упаковка'),
    ('Доставка'),
    ('Возврат');



