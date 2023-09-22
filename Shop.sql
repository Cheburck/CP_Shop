CREATE DATABASE shop;

CONNECT shop

CREATE TABLE client
(
  client_id SERIAL PRIMARY KEY,
  name_client VARCHAR(30)
);

CREATE TABLE supplier
(
    supplier_id SERIAL PRIMARY KEY,
    name_supplier VARCHAR(30)
);

CREATE TABLE category
(
    category_id SERIAL PRIMARY KEY,
    name_category VARCHAR(30)
);

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
    name_product VARCHAR(30),
    category_id BIGINT NOT NULL,
    supplier_id BIGINT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE CASCADE,
    FOREIGN KEY (supplier_id)
        REFERENCES supplier (supplier_id)
        ON DELETE CASCADE
);

CREATE TABLE order
(
    order_id SERIAL PRIMARY KEY,
    name_product VARCHAR(30),
    category_id BIGINT NOT NULL,
    supplier_id BIGINT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE CASCADE,
    FOREIGN KEY (supplier_id)
        REFERENCES supplier (supplier_id)
        ON DELETE CASCADE
);

CREATE TABLE buy
(
    buy_id SERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    FOREIGN KEY (client_id)
        REFERENCES client (client_id)
        ON DELETE CASCADE
);

CREATE TABLE buy_product
(
    buy_product_id SERIAL PRIMARY KEY,
    buy_id INT NOT NULL,
    product_id INT NOT NULL,
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
    name_step VARCHAR(30)
)

CREATE TABLE buy_step
(
    buy_step_id SERIAL PRIMARY KEY,
    buy_id BIGINT NOT NULL,
    step_id BIGINT NOT NULL,
    date_step_beg DATE,
    date_step_end DATE,
    FOREIGN KEY (buy_id)
        REFERENCES buy (buy_id)
        ON DELETE CASCADE,
    FOREIGN KEY (step_id)
        REFERENCES step (step_id)
        ON DELETE CASCADE
)
