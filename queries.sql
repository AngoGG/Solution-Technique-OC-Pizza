-- Sélection des informations et addresses de tous les restaurants

SELECT rest.id, rest.address_id, rest.name, rest.phone_number, address.city, address.zip_code,
    address.country, address.address_infos, address.address_additional_infos
FROM oc_pizza.restaurant rest JOIN oc_pizza.address address ON address.id = rest.address_id

-- Sélection des informations et addresses de tous les clients

SELECT us.id, us.first_name, us.last_name, us.phone_number, us.email, us.password,
    address.city, address.zip_code, address.country, address.address_infos, address.address_additional_infos,
    role.name, rest.name restaurant_name

FROM oc_pizza.user us
    JOIN oc_pizza.address address ON address.id = us.address_id
    JOIN oc_pizza.role role ON role.id = us.role_id
    JOIN oc_pizza.restaurant rest ON rest.id = us.restaurant_id


-- Sélection des informations et du contenu d'une commande
SELECT rest.name pizzeria,
    ord.reference order_reference, bill.amount order_amount, stat.name commande_status,
    ord.delivery, addr.address_infos delivery_street, addr.city delivery_city,
    us.first_name user_firstname, us.last_name user_lastname,
    cat.name article, line.quantity, line.price unit_price
FROM oc_pizza.user_order ord
    JOIN oc_pizza.restaurant rest ON rest.id = ord.restaurant_id
    JOIN oc_pizza.bill bill ON bill.order_reference = ord.reference
    JOIN oc_pizza.orderline line ON line.order_reference = ord.reference
    JOIN oc_pizza.order_status stat ON stat.id = ord.status_id
    JOIN oc_pizza.user us ON us.id = ord.user_id
    JOIN oc_pizza.role rol ON rol.id = us.role_id
    JOIN oc_pizza.article_catalogue cat ON cat.id = line.article_id
    JOIN oc_pizza.address addr ON addr.id = ord.address_id
WHERE ord.reference = 1

-- Sélection des commandes d'un restaurant
SELECT rest.name pizzeria,
    ord.reference order_reference, ord.delivery,
    stat.name commande_status
FROM oc_pizza.user_order ord
    JOIN oc_pizza.restaurant rest ON rest.id = ord.restaurant_id
    JOIN oc_pizza.order_status stat ON stat.id = ord.status_id
WHERE rest.id = 2

-- Lister tous les aliments hors stock dans tous les restaurants
SELECT rest.name, rec.name, prod.name, stock.quantity quantity_stock, qty.quantity required
FROM oc_pizza.stock stock
    JOIN oc_pizza.restaurant rest ON rest.id = stock.restaurant_id
    JOIN oc_pizza.product prod ON prod.id = stock.product_id
    JOIN oc_pizza.product_quantity qty ON qty.product_id = stock.product_id
    JOIN oc_pizza.recipe rec ON rec.id = qty.recipe_id
        AND stock.quantity < qty.quantity
ORDER BY rest.name ASC

-- Liste  produits vendus à l'unité hors stock pour chaque restaurant (1 ou moins)
SELECT rest.name, prod.name, is_ingredient, stock.quantity
FROM oc_pizza.stock stock
    JOIN oc_pizza.product prod ON stock.product_id = prod.id
    JOIN oc_pizza.restaurant rest ON rest.id = stock.restaurant_id
WHERE prod.is_ingredient = False
    AND stock.quantity <= 1
ORDER BY rest.name ASC