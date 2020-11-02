CREATE SCHEMA oc_pizza
    AUTHORIZATION postgres;


CREATE TABLE oc_pizza.recipe
(
    id SERIAL NOT NULL,
    name VARCHAR NOT NULL,
    CONSTRAINT recipe_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.product
(
    id SERIAL NOT NULL,
    name VARCHAR NOT NULL,
    is_ingredient BOOLEAN NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.product_quantity
(
    recipe_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    CONSTRAINT product_quantity_pk PRIMARY KEY (recipe_id, product_id)
);


CREATE TABLE oc_pizza.order_status
(
    id SERIAL NOT NULL,
    name VARCHAR NOT NULL,
    CONSTRAINT order_status_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.address
(
    id SERIAL NOT NULL,
    city VARCHAR NOT NULL,
    address_infos VARCHAR NOT NULL,
    address_additional_infos VARCHAR,
    zip_code VARCHAR NOT NULL,
    country VARCHAR NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.restaurant
(
    id SERIAL NOT NULL,
    address_id INTEGER NOT NULL,
    name VARCHAR NOT NULL,
    phone_number VARCHAR NOT NULL,
    CONSTRAINT restaurant_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.article_catalogue
(
    id SERIAL NOT NULL,
    restaurant_id INTEGER NOT NULL,
    product_id INTEGER,
    recipe_id INTEGER,
    price NUMERIC(5,2) NOT NULL,
    name VARCHAR NOT NULL,
    available BOOLEAN NOT NULL,
    image_name VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    CONSTRAINT article_catalogue_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.stock
(
    restaurant_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    CONSTRAINT stock_pk PRIMARY KEY (restaurant_id, product_id)
);


CREATE TABLE oc_pizza.role
(
    id SERIAL NOT NULL,
    name VARCHAR NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.user
(
    id SERIAL NOT NULL,
    role_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    restaurant_id INTEGER,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    phone_number VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.user_order
(
    reference SERIAL NOT NULL,
    user_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    date_order DATE NOT NULL,
    payment_mode VARCHAR NOT NULL,
    delivery BOOLEAN NOT NULL,
    order_paid BOOLEAN NOT NULL,
    CONSTRAINT user_order_pk PRIMARY KEY (reference)
);


CREATE SEQUENCE oc_pizza.orderline_id_seq;

CREATE TABLE oc_pizza.orderline
(
    id SERIAL NOT NULL,
    order_reference INTEGER NOT NULL,
    article_id INTEGER NOT NULL,
    price NUMERIC(6,2) NOT NULL,
    quantity INTEGER NOT NULL,
    CONSTRAINT orderline_pk PRIMARY KEY (id)
);


ALTER SEQUENCE oc_pizza.orderline_id_seq
OWNED BY oc_pizza.orderline.id;

CREATE TABLE oc_pizza.bill
(
    bill_number SERIAL NOT NULL,
    order_reference INTEGER NOT NULL,
    date DATE NOT NULL,
    amount NUMERIC(6,2) NOT NULL,
    CONSTRAINT bill_pk PRIMARY KEY (bill_number)
);


ALTER TABLE oc_pizza.product_quantity ADD CONSTRAINT recipe_product_quantity_fk
FOREIGN KEY (recipe_id)
REFERENCES oc_pizza.recipe (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.article_catalogue ADD CONSTRAINT recipe_article_catalogue_fk
FOREIGN KEY (recipe_id)
REFERENCES oc_pizza.recipe (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.product_quantity ADD CONSTRAINT product_product_quantity_fk
FOREIGN KEY (product_id)
REFERENCES oc_pizza.product (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.stock ADD CONSTRAINT product_stock_fk
FOREIGN KEY (product_id)
REFERENCES oc_pizza.product (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.article_catalogue ADD CONSTRAINT product_article_catalogue_fk
FOREIGN KEY (product_id)
REFERENCES oc_pizza.product (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user_order ADD CONSTRAINT order_status_order_fk
FOREIGN KEY (status_id)
REFERENCES oc_pizza.order_status (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user ADD CONSTRAINT adress_user_id_fk
FOREIGN KEY (address_id)
REFERENCES oc_pizza.address (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.restaurant ADD CONSTRAINT address_restaurant_fk
FOREIGN KEY (address_id)
REFERENCES oc_pizza.address (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user_order ADD CONSTRAINT address_order_fk
FOREIGN KEY (address_id)
REFERENCES oc_pizza.address (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.stock ADD CONSTRAINT restaurant_stock_fk
FOREIGN KEY (restaurant_id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.article_catalogue ADD CONSTRAINT restaurant_article_catalogue_fk
FOREIGN KEY (restaurant_id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user ADD CONSTRAINT restaurant_user_fk
FOREIGN KEY (restaurant_id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user_order ADD CONSTRAINT restaurant_user_order_fk
FOREIGN KEY (restaurant_id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.orderline ADD CONSTRAINT article_catalogue_orderline_fk
FOREIGN KEY (article_id)
REFERENCES oc_pizza.article_catalogue (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user ADD CONSTRAINT role_user_fk
FOREIGN KEY (role_id)
REFERENCES oc_pizza.role (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.user_order ADD CONSTRAINT user_id_order_fk
FOREIGN KEY (user_id)
REFERENCES oc_pizza.user (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.bill ADD CONSTRAINT order_bill_fk
FOREIGN KEY (order_reference)
REFERENCES oc_pizza.user_order (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.orderline ADD CONSTRAINT user_order_orderline_fk
FOREIGN KEY (order_reference)
REFERENCES oc_pizza.user_order (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;