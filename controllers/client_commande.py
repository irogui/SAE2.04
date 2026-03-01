#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


# validation de la commande : partie 2 -- vue pour choisir les adresses (livraision et facturation)
@client_commande.route('/client/commande/valide', methods=['POST'])
def client_commande_valide():
    id_client = session['id_user']

    mycursor = get_db().cursor()

    sql = ''' SELECT variante_id AS id_declinaison_article,
                     quantite,
                     date_ajout,
                     nom_espece AS nom,
                     prix 
                     FROM ligne_panier
                     JOIN variante AS var ON var.id_variante = ligne_panier.variante_id
                     JOIN espece_animal AS espece ON espece.id_espece_animal = var.espece_animal_id 
                     WHERE utilisateur_id = %s; '''
    mycursor.execute(sql, (id_client,))
    articles_panier = mycursor.fetchall()

    if len(articles_panier) >= 1:
        sql = ''' SELECT SUM(quantite*prix) AS prix_total FROM ligne_panier
                                                          JOIN variante on variante.id_variante = ligne_panier.variante_id
                                                          JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id   
                                                          WHERE utilisateur_id = %s;'''
        mycursor.execute(sql, (id_client,))
        prix_total = mycursor.fetchone()['prix_total']
    else:
        prix_total = articles_panier[0]['prix_total'] * articles_panier[0]['quantite']
    # etape 2 : selection des adresses

    return render_template('client/boutique/panier_validation_adresses.html'
                           #, adresses=adresses
                           , articles_panier=articles_panier
                           , prix_total= prix_total
                           , validation=1
                           #, id_adresse_fav=id_adresse_fav
                           )


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    # choix de(s) (l')adresse(s)

    id_client = session['id_user']
    sql = ''' selection du contenu du panier de l'utilisateur '''
    items_ligne_panier = []
    # if items_ligne_panier is None or len(items_ligne_panier) < 1:
    #     flash(u'Pas d\'articles dans le ligne_panier', 'alert-warning')
    #     return redirect('/client/article/show')
                                           # https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    #a = datetime.strptime('my date', "%b %d %Y %H:%M")

    sql = ''' creation de la commande '''

    sql = '''SELECT last_insert_id() as last_insert_id'''
    # numéro de la dernière commande
    for item in items_ligne_panier:
        sql = ''' suppression d'une ligne de panier '''
        sql = "  ajout d'une ligne de commande'"

    get_db().commit()
    flash(u'Commande ajoutée','alert-success')
    return redirect('/client/article/show')




@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''  selection des commandes ordonnées par état puis par date d'achat descendant '''
    commandes = []

    articles_commande = None
    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande != None:
        print(id_commande)
        sql = ''' selection du détails d'une commande '''

        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql = ''' selection des adressses '''

    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )

