#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')



@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article')
    quantite = int(request.form.get('quantite'))

    id_declinaison_article = request.form.get('id_declinaison_article')


    # CAS 1 : Utilisation de + ou ajouter de vue choix
    if id_declinaison_article:

        # Vérifier si déjà dans panier
        sql = '''
                SELECT *
                FROM ligne_panier
                WHERE utilisateur_id = %s AND variante_id = %s
                '''
        mycursor.execute(sql, (id_client, id_declinaison_article))
        ligne = mycursor.fetchone()

        sql = ''' SELECT * FROM variante WHERE id_variante = %s; '''
        mycursor.execute(sql, (id_declinaison_article,))
        stock = mycursor.fetchone()['stock']

        if stock - quantite >= 0:
            if ligne:
                sql = '''
                UPDATE ligne_panier
                SET quantite = quantite + %s
                WHERE utilisateur_id = %s AND variante_id = %s
                '''
                mycursor.execute(sql, (quantite, id_client, id_declinaison_article))

            else:
                sql = '''
                        INSERT INTO ligne_panier (utilisateur_id, variante_id, quantite, date_ajout)
                        VALUES (%s, %s, %s, CURDATE())
                        '''
                mycursor.execute(sql, (id_client, id_declinaison_article, quantite))

            sql = ''' UPDATE variante SET stock = stock - %s WHERE id_variante=%s; '''
            mycursor.execute(sql, (quantite, id_declinaison_article,))

            get_db().commit()
            return redirect('/client/article/show')

        else:
            flash("Il n'y a plus assez d'articles pour traiter votre demande !")
            return redirect('/client/article/show')


    # CAS 2 : Utilisation de bouton ajouter
    else:
        sql = '''
        SELECT id_variante AS id_declinaison_article,
               stock,
               id_couleur,
               nom_couleur AS libelle_couleur
        FROM variante
        LEFT JOIN couleur ON couleur.id_couleur = variante.couleur_id
        WHERE espece_animal_id = %s
        '''
        mycursor.execute(sql, (id_article,))
        declinaisons = mycursor.fetchall()

        # Erreur, pas de declinaison
        if len(declinaisons) == 0:
            return redirect('/client/article/show')

        # Une seule decli donc ajout direct
        elif len(declinaisons) == 1:

            id_declinaison_article = declinaisons[0]['id_declinaison_article']

            sql = '''
            SELECT *
            FROM ligne_panier
            WHERE utilisateur_id = %s AND variante_id = %s
            '''
            mycursor.execute(sql, (id_client, id_declinaison_article))
            ligne = mycursor.fetchone()

            sql = ''' SELECT * FROM variante WHERE id_variante = %s; '''
            mycursor.execute(sql, (id_declinaison_article,))
            stock = mycursor.fetchone()['stock']

            if stock - quantite >= 0:

                if ligne:
                    sql = '''
                    UPDATE ligne_panier
                    SET quantite = quantite + %s
                    WHERE utilisateur_id = %s AND variante_id = %s
                    '''
                    mycursor.execute(sql, (quantite, id_client, id_declinaison_article))
                else:
                    sql = '''
                    INSERT INTO ligne_panier (utilisateur_id, variante_id, quantite, date_ajout)
                    VALUES (%s, %s, %s, CURDATE())
                    '''
                    mycursor.execute(sql, (id_client, id_declinaison_article, quantite))

                sql = ''' UPDATE variante SET stock = stock - %s WHERE id_variante=%s; '''
                mycursor.execute(sql, (quantite, id_declinaison_article,))

                get_db().commit()
                return redirect('/client/article/show')

            else:
                flash("Il n'y a plus assez d'articles pour traiter votre demande !")
                return redirect('/client/article/show')

        # Plusieurs déclinaisons donc affichage vue choix
        else:

            sql = '''
            SELECT id_espece_animal AS id_article,
                   nom_espece AS nom,
                   prix,
                   image
            FROM espece_animal
            WHERE id_espece_animal = %s
            '''
            mycursor.execute(sql, (id_article,))
            article = mycursor.fetchone()

            return render_template(
                'client/boutique/declinaison_article.html',
                declinaisons=declinaisons,
                quantite=quantite,
                article=article
            )


@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    id_client = session['id_user']
    id_declinaison_article = request.form.get('id_declinaison_article')
    quantite = 1

    mycursor = get_db().cursor()
    # ---------
    # partie 2 : on supprime une déclinaison de l'article
    # id_declinaison_article = request.form.get('id_declinaison_article', None)

    sql = ''' SELECT quantite FROM ligne_panier WHERE utilisateur_id = %s AND variante_id = %s; '''
    mycursor.execute(sql, (id_client, id_declinaison_article))
    article_panier = mycursor.fetchone()

    if not(article_panier is None) and article_panier['quantite'] > 1:
        sql = ''' UPDATE ligne_panier SET quantite = quantite - %s WHERE utilisateur_id = %s AND variante_id = %s; '''
        mycursor.execute(sql, (quantite, id_client, id_declinaison_article))
    else:
        sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s AND variante_id; '''
        mycursor.execute(sql, (id_client, id_declinaison_article))

    sql = ''' UPDATE variante SET stock = stock + %s WHERE id_variante = %s;'''
    mycursor.execute(sql, (quantite, id_declinaison_article))

    get_db().commit()
    return redirect('/client/article/show')


@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    client_id = session['id_user']
    mycursor = get_db().cursor()

    sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s; '''
    mycursor.execute(sql, (client_id,))
    get_db().commit()

    return redirect('/client/article/show')


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    id_client = session['id_user']
    id_declinaison_article = request.form.get('id_declinaison_article')

    mycursor = get_db().cursor()

    sql = ''' SELECT quantite FROM ligne_panier WHERE utilisateur_id = %s AND variante_id = %s; '''
    mycursor.execute(sql, (id_client, id_declinaison_article))
    article_panier = mycursor.fetchone()

    sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s AND variante_id = %s; '''
    mycursor.execute(sql, (id_client, id_declinaison_article))

    sql=''' UPDATE variante SET stock = stock + %s WHERE id_variante = %s; '''
    mycursor.execute(sql, (article_panier['quantite'], id_declinaison_article))

    get_db().commit()
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    # test des variables puis

    #On vérifie les filtres choisis, s'il y en a des choisis ils seront mis dans la session
    if(filter_word != None):
        # mise en session des variables
        session["filter_word"] = filter_word

    if (filter_prix_min != None):
        session["filter_prix_min"] = filter_prix_min

    if (filter_prix_max != None):
        session["filter_prix_max"] = filter_prix_max

    if (filter_types != None):
        session["filter_types"] = filter_types
        print("Types!!!!!")
    else:
        print("ALors?")
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    # suppression  des variables en session

    if session["filter_word"] != None:
        session.pop("filter_word")

    if session["filter_prix_min"] != None:
        session.pop("filter_prix_min")

    if session["filter_prix_max"] != None:
        session.pop("filter_prix_max")

    if session["filter_types"] != None:
        session.pop("filter_types")
    print("suppr filtre")
    return redirect('/client/article/show')
