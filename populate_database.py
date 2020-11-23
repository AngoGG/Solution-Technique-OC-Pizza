import psycopg2
import random
from os import environ
from faker import Faker
from data import DATA


class PopulateDatabase:
    def __init__(self, database: str, user: str, password: str) -> None:
        self.database = psycopg2.connect(
            f"dbname={database} user={user} password={password}"
        )
        self.cursor = self.database.cursor()
        self.fake: Faker = Faker("fr_FR")

    def _get_address(self) -> list:

        address_list = []
        for _ in range(40):
            address_list.append(
                {
                    "city": self.fake.city(),
                    "address_infos": self.fake.street_name(),
                    "address_additional_infos": self.fake.building_number(),
                    "zip_code": self.fake.postcode(),
                    "country": "France",
                }
            )
        return address_list

    def insert_address(self) -> None:

        addresses = self._get_address()
        try:

            self.cursor.executemany(
                "INSERT INTO oc_pizza.address(city, address_infos, address_additional_infos, zip_code, country) VALUES (%(city)s, %(address_infos)s, %(address_additional_infos)s, %(zip_code)s, %(country)s);",
                addresses,
            )

            self.database.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    def insert_restaurant(self) -> None:

        for _ in range(5):
            address_id: str = str(_ + 1)
            name: str = f"OC Pizza {_ + 1}"
            phone_number = self.fake.phone_number()
            self.cursor.execute(
                "INSERT INTO oc_pizza.restaurant(address_id, name, phone_number) VALUES (%(address_id)s, %(name)s, %(phone_number)s);",
                {"address_id": address_id, "name": name, "phone_number": phone_number},
            )

            self.database.commit()

    def insert_role(self) -> None:

        roles = ["Equipe Nationale", "Responsable", "Pizzaiolo", "Livreur", "Client"]
        for role in roles:
            self.cursor.execute("INSERT INTO oc_pizza.role(name) VALUES (%s);", (role,))
        self.database.commit()

    def _get_user_info(self) -> list:

        user_list = []
        address_id = 1
        role_id = 2
        restaurant_id = 1
        for _ in range(20):
            user_list.append(
                {
                    "role_id": role_id,
                    "address_id": address_id,
                    "restaurant_id": restaurant_id,
                    "first_name": self.fake.first_name(),
                    "last_name": self.fake.last_name(),
                    "phone_number": self.fake.phone_number(),
                    "email": self.fake.ascii_free_email(),
                    "password": self.fake.md5(raw_output=False),
                }
            )
            address_id += 1
            role_id += 1
            # One user per role for each restaurant, when reached the 4 roles, switch to the second restaurant
            if (_ == 3) or (_ == 7) or (_ == 11) or (_ == 15):
                restaurant_id += 1
                role_id = 2

        return user_list

    def insert_user(self) -> None:

        users = self._get_user_info()
        self.cursor.executemany(
            "INSERT INTO oc_pizza.user_(role_id, address_id, restaurant_id, first_name, last_name, phone_number, email, password) VALUES (%(role_id)s, %(address_id)s, %(restaurant_id)s, %(first_name)s, %(last_name)s, %(phone_number)s, %(email)s, %(password)s);",
            users,
        )

        self.database.commit()

    def insert_national_team(self) -> None:

        national_team = [
            {
                "role_id": 1,
                "address_id": random.randint(0, 40),
                "first_name": self.fake.first_name(),
                "last_name": self.fake.last_name(),
                "phone_number": self.fake.phone_number(),
                "email": self.fake.ascii_free_email(),
                "password": self.fake.md5(raw_output=False),
            },
            {
                "role_id": 1,
                "address_id": random.randint(0, 40),
                "first_name": self.fake.first_name(),
                "last_name": self.fake.last_name(),
                "phone_number": self.fake.phone_number(),
                "email": self.fake.ascii_free_email(),
                "password": self.fake.md5(raw_output=False),
            },
        ]
        self.cursor.executemany(
            "INSERT INTO oc_pizza.user_(role_id, address_id, first_name, last_name, phone_number, email, password) VALUES (%(role_id)s, %(address_id)s, %(first_name)s, %(last_name)s, %(phone_number)s, %(email)s, %(password)s);",
            national_team,
        )

        self.database.commit()

    def insert_product(self) -> None:

        ingredient_list: list = [
            "Sauce Tomate",
            "Mozzarella",
            "Chèvre",
            "Parmabon",
            "Gorgonzola",
            "Jambon",
            "Champignons",
            "Olives",
            "Poivrons",
            "Crème Fraîche",
            "Poulet Fumé",
            "Pommes de terre",
            "Camembert",
            "Tomates Fraîches",
        ]
        product_list: list = [
            "Coca-Cola",
            "Perrier",
            "7Up",
            "Muffin",
            "Tiramisu",
            "Glace Häagen Dazs",
        ]
        for ingredient in ingredient_list:
            self.cursor.execute(
                "INSERT INTO oc_pizza.product(name, is_ingredient) VALUES (%(name)s, %(is_ingredient)s);",
                {"name": ingredient, "is_ingredient": True,},
            )

        for product in product_list:
            self.cursor.execute(
                "INSERT INTO oc_pizza.product(name, is_ingredient) VALUES (%(name)s, %(is_ingredient)s);",
                {"name": product, "is_ingredient": False,},
            )
        self.database.commit()

    def insert_recipe(self) -> None:

        recipe_list: list = [
            "4 Fromages",
            "Reine",
            "Végétarienne",
            "Chicken",
            "Tartiflette",
        ]

        for recipe in recipe_list:
            self.cursor.execute(
                "INSERT INTO oc_pizza.recipe(name) VALUES (%(name)s);",
                {"name": recipe,},
            )
        self.database.commit()

    def insert_article_catalogue(self) -> None:

        for _ in range(5):
            for item in DATA.RECIPE_LIST:
                item["restaurant_id"] = _ + 1
            for item in DATA.PRODUCT_LIST:
                item["restaurant_id"] = _ + 1
            self.cursor.executemany(
                "INSERT INTO oc_pizza.article_catalogue(restaurant_id, recipe_id, unit_price, name, available, image_name, description) VALUES (%(restaurant_id)s, %(recipe_id)s, %(unit_price)s, %(name)s, %(available)s, %(image_name)s, %(description)s);",
                DATA.RECIPE_LIST,
            )
            self.cursor.executemany(
                "INSERT INTO oc_pizza.article_catalogue(restaurant_id, product_id, unit_price, name, available, image_name, description) VALUES (%(restaurant_id)s, %(product_id)s, %(unit_price)s, %(name)s, %(available)s, %(image_name)s, %(description)s);",
                DATA.PRODUCT_LIST,
            )
        self.database.commit()

    def insert_product_quantity(self):

        self.cursor.executemany(
            "INSERT INTO oc_pizza.product_quantity(recipe_id, product_id, quantity) VALUES (%(recipe_id)s, %(product_id)s, %(quantity)s);",
            DATA.PRODUCT_QUANTITY,
        )
        self.database.commit()

    def insert_stock(self):

        for _ in range(5):
            for item in DATA.PRODUCT_STOCK:
                item["restaurant_id"] = _ + 1
            self.cursor.executemany(
                "INSERT INTO oc_pizza.stock(restaurant_id, product_id, quantity) VALUES (%(restaurant_id)s, %(product_id)s, %(quantity)s);",
                DATA.PRODUCT_STOCK,
            )
            self.database.commit()

    def insert_order_status(self) -> None:

        status_list = [
            "A traiter",
            "En cours de préparation",
            "A livrer",
            "A retirer",
            "Terminée",
            "Annulée",
        ]
        for status in status_list:
            self.cursor.execute(
                "INSERT INTO oc_pizza.order_status(name) VALUES (%s);", (status,)
            )
        self.database.commit()

    def insert_order(self):
        order_reference = 1
        for order in DATA.ORDER_LIST:
            order["order_reference"] = order_reference
            self.cursor.execute(
                "INSERT INTO oc_pizza.user_order(user_id, status_id, address_id, restaurant_id, date_order, payment_mode, delivery, order_paid) VALUES (%(user_id)s, %(status_id)s, %(address_id)s, %(restaurant_id)s, %(date_order)s, %(payment_mode)s, %(delivery)s, %(order_paid)s);",
                order,
            )
            self.database.commit()
            self._insert_order_line(order_reference, order["date_order"], order["order_paid"])
            order_reference += 1

    def _insert_order_line(self, order_reference: int, date_order, order_paid) -> None:
        article_list = random.sample(range(1, 11), random.randint(1, 5))
        total_amount = 0
        for article_id in article_list:
            quantity = random.randint(1, 5)
            self.cursor.execute(f'SELECT unit_price FROM oc_pizza.article_catalogue WHERE id={article_id}')
            article_price = self.cursor.fetchone()
            self.cursor.execute(
                "INSERT INTO oc_pizza.orderline(order_reference,article_id, unit_price, quantity) VALUES (%(order_reference)s, %(article_id)s, %(unit_price)s, %(quantity)s);",
                {
                    "order_reference": order_reference,
                    "article_id": article_id,
                    "unit_price": article_price,
                    "quantity": quantity,
                },
            )
            total_amount += article_price[0]*quantity
            self.database.commit()
        if order_paid:
            self._insert_bill(order_reference, total_amount, date_order)
    
    def _insert_bill(self, order_reference: int, total_amount: int, date_order) -> None:
        self.cursor.execute(
                "INSERT INTO oc_pizza.bill(order_reference, date, amount) VALUES (%(order_reference)s, %(date_order)s, %(amount)s);",
                {
                    "order_reference": order_reference,
                    "date_order": date_order,
                    "amount": total_amount,
                },
            )
        self.database.commit()

    def ko_insert_order_line(self):
        for order_reference in range(6):
            article_number = random.randint(1, 5)
            for new_article in range(article_number):
                self.cursor.execute(
                    "INSERT INTO oc_pizza.orderline(order_reference,article_id, unit_price, quantity) VALUES (%(order_reference)s, %(article_id)s, %(unit_price)s, %(quantity)s);",
                    {
                        "order_reference": order_reference + 1,
                        "article_id": random.randint(1, 11),
                        "unit_price": self.fake.pyfloat(
                            positive=True, left_digits=2, right_digits=2
                        ),
                        "quantity": random.randint(1, 3),
                    },
                )
                self.database.commit()
            order_reference += 1

def main() -> None:
    populate_database: PopulateDatabase = PopulateDatabase(
        environ['DB_NAME'], environ['DB_USER'], environ['DB_PASSWORD'],
    )
    populate_database.insert_address()
    populate_database.insert_restaurant()
    populate_database.insert_role()
    populate_database.insert_user()
    populate_database.insert_national_team()
    populate_database.insert_product()
    populate_database.insert_recipe()
    populate_database.insert_article_catalogue()
    populate_database.insert_product_quantity()
    populate_database.insert_stock()
    populate_database.insert_order_status()
    populate_database.insert_order()


if __name__ == "__main__":
    main()
