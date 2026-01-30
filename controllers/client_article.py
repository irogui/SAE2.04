#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__, template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')              # remplace /client
def client_article_show():                                 # remplace client_index

    list_param = []
    condition_and = ""

    # utilisation du filtre
    sql3 = ''' prise en compte des commentaires et des notes dans le SQL    '''
    articles = []

    # pour le filtre
    types_article = []

    articles_panier = []


    id_client = session['id_user']

    mycursor = get_db().cursor()

    sql = ''' SELECT id_espece_animal AS id_article, nom_espece AS nom, prix, photo AS image, stock FROM espece_animal ORDER BY nom_espece; '''
    mycursor.execute(sql)
    articles = mycursor.fetchall()

    sql = ''' SELECT id_categorie_animal AS id_type_article, nom_categorie AS libelle FROM categorie_animal ORDER BY nom_categorie; '''
    mycursor.execute(sql)
    items_filtre = mycursor.fetchall()

    sql = ''' SELECT    id_espece_animal,
                        nom_espece AS nom,  
                        
                        FROM ligne_panier 
                        ORDER BY ; '''
    mycursor.execute(sql)
    articles_panier = mycursor.fetchall()


    if len(articles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None

    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           #, prix_total=prix_total
                           , items_filtre=items_filtre
                           )
