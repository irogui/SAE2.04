#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__, template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')              # remplace /client
def client_article_show():                                 # remplace client_index


    # Création de la condition WHERE pour le filtre
    condition = []
    parametre = []
    condition_and = ""

    list_param = session.get("filter_types") or []
    if (list_param != []):
        print('bab')
        print(list_param)
        placeholders = ",".join(["%s"] * len(list_param))
        condition.append(f"nom_categorie IN ({placeholders})")
        parametre.extend(list_param)
    else:
        print("list_param NONE")


    prix_min = session.get("filter_prix_min") or None

    if prix_min != None:
        print(prix_min)
        condition.append("prix >= %s")
        parametre.append(prix_min)


    prix_max = session.get("filter_prix_max") or None

    if prix_max != None:
        condition.append("prix <= %s")
        parametre.append(prix_max)


    filtre_texte = session.get("filter_word") or None

    if filtre_texte != None:
        condition.append("nom_espece LIKE %s")
        parametre.append(f"%{filtre_texte}%")

    if condition != []:
        condition_and ="WHERE " + " AND ".join(condition)


    # utilisation du filtre
    sql3 = ''' prise en compte des commentaires et des notes dans le SQL    '''
    articles = []

    # pour le filtre
    types_article = []


    id_client = session['id_user']

    mycursor = get_db().cursor()

    sql = f''' SELECT espece_animal.id_espece_animal AS id_article,
                     espece_animal.nom_espece AS nom,
                     espece_animal.prix,
                     espece_animal.image,
                     SUM(stock) AS stock,
                     COUNT(id_variante) AS nb_declinaison
                     
                     FROM espece_animal
                     JOIN variante ON variante.espece_animal_id = espece_animal.id_espece_animal
                     JOIN categorie_animal AS cat ON cat.id_categorie_animal = espece_animal.categorie_animal_id
                     {condition_and}
                     
                     GROUP BY espece_animal.id_espece_animal, espece_animal.nom_espece, espece_animal.prix, espece_animal.image
                     ORDER BY nom; '''
    mycursor.execute(sql, parametre)
    articles = mycursor.fetchall()

    sql = ''' SELECT nom_categorie AS id_type_article, nom_categorie AS libelle FROM categorie_animal ORDER BY nom_categorie; '''
    mycursor.execute(sql)
    items_filtre = mycursor.fetchall()

    sql = ''' SELECT nom_espece AS nom,
                     id_couleur, 
                     nom_couleur AS libelle_couleur,
                     quantite,
                     prix,
                     stock,
                     id_variante AS id_declinaison_article
                     
                     FROM variante
                     JOIN ligne_panier on variante.id_variante = ligne_panier.variante_id
                     JOIN couleur ON couleur.id_couleur = variante.couleur_id
                     JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id
                    
                     WHERE utilisateur_id = %s    
                     ORDER BY date_ajout;'''
    mycursor.execute(sql, id_client)
    articles_panier = mycursor.fetchall()

    sql_total = '''
        SELECT SUM(espece_animal.prix * ligne_panier.quantite) AS prix_total
        FROM ligne_panier
        JOIN variante ON variante.id_variante = ligne_panier.variante_id
        JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id
        
        WHERE ligne_panier.utilisateur_id = %s;
    '''
    mycursor.execute(sql_total, id_client)
    result = mycursor.fetchone()

    if result['prix_total'] is not None:
        prix_total = result['prix_total']
    else:
        prix_total = None


    #if len(articles_panier) >= 1:
    #    prix_total = None
    #else:
    #   prix_total = None

    print(prix_total)
    if condition_and != "":
        print(condition_and)
    else:
        print("vide!")

    if parametre != []:
        print(parametre)
    else:
        print("vide!")

    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           , prix_total=prix_total
                           , items_filtre=items_filtre
                           )