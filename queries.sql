-- Sélection des informations et addresses de tous les restaurants
SELECT rest.name restaurant_name, rest.phone_number, address.city, address.zip_code,
    address.country, address.address_infos, address.address_additional_infos
FROM oc_pizza.restaurant rest JOIN oc_pizza.address address ON address.id = rest.address_id

-- Sélection des informations et addresses de tous les utilisateurs par restaurant
SELECT us.first_name, us.last_name, us.phone_number, us.email, us.password,
    address.city, address.zip_code, address.country, address.address_infos, address.address_additional_infos,
    role.name user_role, rest.name restaurant_name
FROM oc_pizza.user_ us
    JOIN oc_pizza.address address ON address.id = us.address_id
    JOIN oc_pizza.role role ON role.id = us.role_id
    JOIN oc_pizza.restaurant rest ON rest.id = us.restaurant_id
ORDER BY restaurant_name ASC


-- Sélection des informations et du contenu d'une commande
SELECT rest.name pizzeria,
    ord.reference order_reference, ord.order_paid, stat.name commande_status, preparator.first_name preparator,
    ord.delivery, deliverer.first_name deliverer, addr.address_infos delivery_street, addr.city delivery_city,
    client.first_name client_firstname, client.last_name client_lastname,
    cat.name article, line.quantity, line.unit_price
FROM oc_pizza.user_order ord
    JOIN oc_pizza.restaurant rest ON ord.restaurant_id = rest.id
    JOIN oc_pizza.orderline line ON ord.reference = line.order_reference
    JOIN oc_pizza.order_status stat ON ord.status_id = stat.id
    JOIN oc_pizza.user_ client ON ord.client_id = client.id
    LEFT OUTER JOIN oc_pizza.user_ preparator ON ord.preparator_id = preparator.id
    LEFT OUTER JOIN oc_pizza.user_ deliverer ON ord.deliverer_id = deliverer.id
    JOIN oc_pizza.article_catalogue cat ON line.article_id = cat.id
    JOIN oc_pizza.address addr ON ord.address_id = addr.id
WHERE ord.reference = 5

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


-- Requête pour connaître une recette
SELECT rec.name recette_name, cat.description recette_description, prod.name product_name, rec_prod.quantity
FROM oc_pizza.product_quantity rec_prod
    JOIN oc_pizza.recipe rec ON rec_prod.recipe_id = rec.id
    JOIN oc_pizza.article_catalogue cat ON rec.id = cat.id
    JOIN oc_pizza.product prod ON rec_prod.product_id = prod.id
WHERE rec.id = 1


-- Requête pour connaître les meilleures ventes par restaurant
SELECT rest.name restaurant, cat.name article_name, sum(line.quantity) sells
FROM oc_pizza.restaurant rest
    JOIN oc_pizza.user_order ord ON rest.id = ord.restaurant_id
    JOIN oc_pizza.orderline line ON ord.reference = line.order_reference
    JOIN oc_pizza.article_catalogue cat ON line.article_id = cat.id
GROUP BY restaurant, article_name
ORDER BY restaurant, sells DESC

-- Requête pour connaître le chiffre d'affaire pour l'année en cours
SELECT rest.name restaurant, sum(bill.amount) turnover
FROM oc_pizza.restaurant rest
    JOIN oc_pizza.user_order ord ON rest.id = ord.restaurant_id
    JOIN oc_pizza.bill bill ON ord.reference = bill.order_reference
WHERE date_part('year', ord.date_order) = date_part('year', CURRENT_DATE)
GROUP BY restaurant
ORDER BY turnover DESC

-- Requête sélection facture d'un restaurant
SELECT bill_number, order_reference, date, amount
FROM oc_pizza.bill
WHERE order_reference = 2