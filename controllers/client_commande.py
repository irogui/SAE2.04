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

    id_client = session['id_user']
    mycursor = get_db().cursor()

    sql = ''' SELECT id_variante,
                     quantite,
                     prix
                     FROM ligne_panier
                     JOIN variante ON variante.id_variante = ligne_panier.variante_id
                     JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id 
                     WHERE utilisateur_id = %s; '''
    mycursor.execute(sql, (id_client,))
    items_ligne_panier = mycursor.fetchall()

    if items_ligne_panier is None or len(items_ligne_panier) < 1:
        flash(u'Pas d\'articles dans le ligne_panier', 'alert-warning')
        return redirect('/client/article/show')

    # https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    #a = datetime.strptime('my date', "%b %d %Y %H:%M")

    sql = ''' INSERT INTO commande(date_achat, utilisateur_id, etat_id) VALUES (NOW(), %s, %s); '''
    mycursor.execute(sql, (id_client, 1))

    id_commande = mycursor.lastrowid

    for item in items_ligne_panier:
        sql = ''' INSERT INTO ligne_commande(variante_id, commande_id, prix_commande, quantite) VALUES (%s, %s, %s, %s); '''
        mycursor.execute(sql, (item['id_variante'], id_commande, item['prix'], item['quantite']))

    sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s; '''
    mycursor.execute(sql, (id_client,))

    get_db().commit()
    flash(u'Commande ajoutée','alert-success')
    return redirect('/client/article/show')


@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']

    #selection des commandes ordonnées par état puis par date d'achat descendant
    sql = ''' SELECT id_commande, date_achat, etat_id, libelle_etat AS libelle, SUM(quantite) AS nbr_articles, SUM(quantite*prix_commande) AS prix_total
                  FROM commande
                  JOIN utilisateur ON utilisateur.id_utilisateur = commande.utilisateur_id
                  JOIN etat ON etat.id_etat = commande.etat_id
                  JOIN ligne_commande ON ligne_commande.commande_id = commande.id_commande
                  WHERE utilisateur.id_utilisateur = %s
                  GROUP BY id_commande
                  ORDER BY etat_id, date_achat DESC;'''

    mycursor.execute(sql, (id_client,))
    commandes = mycursor.fetchall()

    id_commande = request.args.get('id_commande', None)

    if id_commande is not None:
        sql = ''' SELECT nom_espece AS nom, quantite, prix, SUM(quantite*prix) AS prix_ligne
        
                          FROM commande
                          JOIN utilisateur ON utilisateur.id_utilisateur = commande.utilisateur_id
                          JOIN ligne_commande ON ligne_commande.commande_id = commande.id_commande
                          JOIN variante ON variante.id_variante = ligne_commande.variante_id
                          JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id
                          
                          WHERE commande.id_commande = %s
                          GROUP BY nom, quantite, prix; '''

        mycursor.execute(sql, (id_commande,))
        articles_commande = mycursor.fetchall()

    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande != None:
        sql = ''' selection du détails d'une commande '''

        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql = '''  '''


    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )