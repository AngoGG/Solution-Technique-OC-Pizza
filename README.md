# OC-P6-Solution-Technique-OC-Pizza

Ce répertoire contient tout le nécessaire pour suivre et effectuer le projet 6, notamment les scripts Python de remplissage de la base de données qui ne sont pas demandés explicitement dans les livrables de soutenance.

L'intégralité des manipulations de base de données a été effectuée avec l'aide de pgadmin. Dans tous les cas avant manipulation il est nécessaire de créer la base de données avant de pouvoir:

- Charger le dump
- Créer un nouveau jeu de données.

## Chargement du jeu de données fourni

Dans pgadmin:

- Click droit sur la base de données désirée.
- Sélectionner l'option **Restore...**
- Sélectionner le fichier `oc-pizza.dump`
- Cliquer sur Restore

La base de données sera maintenant en place.

## Création d'un nouveau jeu de données

Il est également possible de générer un nouveau jeu de données grâce au script python fourni dans ce répertoire git, le jeu de donnée fourni a été généré avec ce dernier.

Il nécessite la création préalable de la base de données.

Tout d'abord il faut récupérer le présent répertoire git. Puis éxécuter le script `oc-pizza.sql` dans la base de données choisie.

Il faut ensuite renseigner dans le fichier .env les informations nécessaires aux intéractions avec la base de données:

```bash
- DB_NAME => "Nom de la base de données créé pour le projet"
- DB_USER => "Nom de l'utlisateur postgre à utiliser pour cette base de données"
- DB_PASSWORD => "Mot de passe de l'utilisateur"
```

Puis mettre en place l'environnement virtuel avec pipenv:

```bash
pipenv install
```

Une fois effectué, lancer le script avec la commande suivante:

```bash
pipenv run python database.py
```

## Test du jeu de données

Afin de tester le jeu de données fourni ou généré, un ensemble de requêtes SQL est fourni dans le fichier `queries.sql`.
