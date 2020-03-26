
CREATE TABLE oc_pizza.ingredient (
                name VARCHAR NOT NULL,
                CONSTRAINT ingredient_pk PRIMARY KEY (name)
);


CREATE TABLE oc_pizza.product (
                reference INTEGER NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT product_pk PRIMARY KEY (reference)
);


CREATE TABLE oc_pizza.IngredientQuantity (
                product_reference INTEGER NOT NULL,
                ingredient_name VARCHAR NOT NULL,
                CONSTRAINT ingredientquantity_pk PRIMARY KEY (product_reference, ingredient_name)
);


CREATE TABLE oc_pizza.recipe (
                product_reference INTEGER NOT NULL,
                name VARCHAR NOT NULL,
                description VARCHAR NOT NULL,
                CONSTRAINT recipe_pk PRIMARY KEY (product_reference)
);


CREATE TABLE oc_pizza.catalog (
                product_reference INTEGER NOT NULL,
                description VARCHAR NOT NULL,
                CONSTRAINT catalog_pk PRIMARY KEY (product_reference)
);


CREATE TABLE oc_pizza.ProductPrice (
                product_reference INTEGER NOT NULL,
                price REAL NOT NULL,
                CONSTRAINT productprice_pk PRIMARY KEY (product_reference)
);


CREATE TABLE oc_pizza.ProductImage (
                product_reference INTEGER NOT NULL,
                price REAL NOT NULL,
                CONSTRAINT productimage_pk PRIMARY KEY (product_reference)
);


CREATE SEQUENCE oc_pizza.restaurant_id_seq;

CREATE TABLE oc_pizza.restaurant (
                id INTEGER NOT NULL DEFAULT nextval('oc_pizza.restaurant_id_seq'),
                name VARCHAR NOT NULL,
                phone_number VARCHAR NOT NULL,
                CONSTRAINT restaurant_pk PRIMARY KEY (id)
);


ALTER SEQUENCE oc_pizza.restaurant_id_seq OWNED BY oc_pizza.restaurant.id;

CREATE TABLE oc_pizza.stock (
                id INTEGER NOT NULL,
                product_name VARCHAR NOT NULL,
                quantity INTEGER NOT NULL,
                CONSTRAINT stock_pk PRIMARY KEY (id, product_name)
);


CREATE TABLE oc_pizza.user (
                id INTEGER NOT NULL,
                restaurant_id INTEGER NOT NULL,
                first_name VARCHAR NOT NULL,
                last_name VARCHAR NOT NULL,
                phone_number VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password VARCHAR NOT NULL,
                role VARCHAR NOT NULL,
                CONSTRAINT user_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.address (
                id INTEGER NOT NULL,
                street_address VARCHAR NOT NULL,
                city VARCHAR NOT NULL,
                zip_code VARCHAR NOT NULL,
                country VARCHAR NOT NULL,
                CONSTRAINT address_pk PRIMARY KEY (id)
);


CREATE TABLE oc_pizza.order (
                reference INTEGER NOT NULL,
                restaurant_id INTEGER NOT NULL,
                address_id INTEGER NOT NULL,
                user_id INTEGER NOT NULL,
                date_order DATE NOT NULL,
                payment_mode VARCHAR NOT NULL,
                delivery BOOLEAN NOT NULL,
                CONSTRAINT order_pk PRIMARY KEY (reference)
);


CREATE TABLE oc_pizza.order_line (
                order_reference INTEGER NOT NULL,
                product_reference INTEGER NOT NULL,
                quantity INTEGER NOT NULL,
                price REAL NOT NULL,
                CONSTRAINT order_line_pk PRIMARY KEY (order_reference, product_reference)
);


CREATE TABLE oc_pizza.bill (
                number INTEGER NOT NULL,
                order_reference INTEGER NOT NULL,
                date DATE NOT NULL,
                CONSTRAINT bill_pk PRIMARY KEY (number)
);


CREATE TABLE oc_pizza.order_status (
                order_reference INTEGER NOT NULL,
                status VARCHAR NOT NULL,
                is_paid BOOLEAN NOT NULL,
                CONSTRAINT order_status_pk PRIMARY KEY (order_reference)
);


ALTER TABLE oc_pizza.IngredientQuantity ADD CONSTRAINT ingredient_ingredientquantity_fk
FOREIGN KEY (ingredient_name)
REFERENCES oc_pizza.ingredient (name)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.stock ADD CONSTRAINT ingredient_stock_fk
FOREIGN KEY (product_name)
REFERENCES oc_pizza.ingredient (name)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order_line ADD CONSTRAINT product_order_line_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.catalog ADD CONSTRAINT product_catalog_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.ProductImage ADD CONSTRAINT product_productprice_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.ProductPrice ADD CONSTRAINT product_productimage_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.recipe ADD CONSTRAINT product_recipe_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.IngredientQuantity ADD CONSTRAINT product_ingredientquantity_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.product (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.ProductImage ADD CONSTRAINT recipe_productimage_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.recipe (product_reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.ProductImage ADD CONSTRAINT catalog_productprice_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.catalog (product_reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.ProductPrice ADD CONSTRAINT catalog_productimage_fk
FOREIGN KEY (product_reference)
REFERENCES oc_pizza.catalog (product_reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.address ADD CONSTRAINT restaurant_address_fk
FOREIGN KEY (id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order ADD CONSTRAINT restaurant_order_fk
FOREIGN KEY (restaurant_id)
REFERENCES oc_pizza.restaurant (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.stock ADD CONSTRAINT restaurant_stock_fk
FOREIGN KEY (id)
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

ALTER TABLE oc_pizza.address ADD CONSTRAINT user_address_fk
FOREIGN KEY (id)
REFERENCES oc_pizza.user (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order ADD CONSTRAINT user_order_fk
FOREIGN KEY (user_id)
REFERENCES oc_pizza.user (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order ADD CONSTRAINT address_order_fk
FOREIGN KEY (address_id)
REFERENCES oc_pizza.address (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order_status ADD CONSTRAINT order_order_status_fk
FOREIGN KEY (order_reference)
REFERENCES oc_pizza.order (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.bill ADD CONSTRAINT order_bill_fk
FOREIGN KEY (order_reference)
REFERENCES oc_pizza.order (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE oc_pizza.order_line ADD CONSTRAINT order_order_line_fk
FOREIGN KEY (order_reference)
REFERENCES oc_pizza.order (reference)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
