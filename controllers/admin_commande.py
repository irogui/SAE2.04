#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, flash, session

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin')
@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    admin_id = session['id_user']

    mycursor = get_db().cursor()
    sql = ''' SELECT    commande.id_commande,
                        utilisateur.login,
                        commande.date_achat,
                        commande.etat_id,
                        etat.libelle_etat AS libelle,
                        SUM(ligne_commande.quantite) AS nbr_articles,
                        SUM(ligne_commande.prix_commande * ligne_commande.quantite) AS prix_total
                
                FROM commande
                JOIN utilisateur ON utilisateur.id_utilisateur = commande.utilisateur_id
                JOIN etat ON etat.id_etat = commande.etat_id
                LEFT JOIN ligne_commande ON ligne_commande.commande_id = commande.id_commande
                
                GROUP BY 
                        commande.id_commande,
                        utilisateur.login,
                        commande.date_achat,
                        commande.etat_id,
                        etat.libelle_etat
                
                ORDER BY commande.date_achat DESC;'''
    mycursor.execute(sql)
    commandes = mycursor.fetchall()

    articles_commande = None
    commande_adresses = None

    id_commande = request.args.get('id_commande', None)

    if id_commande != None:
        sql = ''' SELECT nom_espece AS nom,
                                    SUM(quantite) AS quantite,
                                    prix,
                                    SUM(quantite * prix_commande) AS prix_ligne,
                                    COUNT(DISTINCT id_variante) AS nb_declinaisons,
                                    GROUP_CONCAT(DISTINCT nom_couleur) AS libelle_couleur

                                FROM ligne_commande
                                JOIN variante ON id_variante = variante_id
                                JOIN espece_animal ON id_espece_animal = espece_animal_id
                                JOIN couleur ON id_couleur = couleur_id

                                WHERE commande_id = %s

                                GROUP BY id_espece_animal, prix_commande; '''
        mycursor.execute(sql, id_commande)
        articles_commande = mycursor.fetchall()


        commande_adresses = []


    return render_template('admin/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )


@admin_commande.route('/admin/commande/valider', methods=['get','post'])
def admin_commande_valider():
    commande_id = request.form.get('id_commande', None)
    mycursor = get_db().cursor()

    if commande_id != None:
        print(commande_id)
        sql = ''' UPDATE commande SET etat_id = 3 WHERE id_commande = %s;'''
        mycursor.execute(sql, commande_id)
        get_db().commit()
    return redirect('/admin/commande/show')
