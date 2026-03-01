#! /usr/bin/python
# -*- coding:utf-8 -*-
import math
import os.path
from random import random

from flask import Blueprint
from flask import request, render_template, redirect, flash
#from werkzeug.utils import secure_filename

from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__, template_folder='templates')


@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()
    sql = ''' SELECT id_espece_animal AS id_article,
              nom_espece AS nom,
              id_categorie_animal AS type_article_id,
              nom_categorie AS libelle,
              prix,
              SUM(stock) AS stock,
              image,
              COUNT(id_variante) AS nb_declinaisons

              FROM espece_animal
              LEFT JOIN variante ON variante.espece_animal_id = espece_animal.id_espece_animal
              JOIN categorie_animal ON categorie_animal.id_categorie_animal = espece_animal.categorie_animal_id
              
              GROUP BY
                  id_espece_animal,
                  nom_espece,
                  id_categorie_animal,
                  nom_categorie,
                  prix,
                  image
              
              ORDER BY id_espece_animal;  
              '''

    mycursor.execute(sql)
    articles = mycursor.fetchall()
    return render_template('admin/article/show_article.html', articles=articles)


@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()

    sql = ''' SELECT id_categorie_animal AS id_type_article, 
                     nom_categorie AS libelle
                     FROM categorie_animal;'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = ''' SELECT id_couleur,
                     nom_couleur
                     FROM couleur; '''
    #mycursor.execute(sql)
    #couleurs = mycursor.fetchall()

    return render_template('admin/article/add_article.html', types_article=types_article
        #,couleurs=couleurs
        )


@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()

    nom = request.form.get('nom', '')
    prix = request.form.get('prix', '')
    poids_moyen = request.form.get('poids_moyen', '')
    taille = request.form.get('taille', '')
    longueur_vie = request.form.get('longueur_vie', '')
    description = request.form.get('description', '')
    image = request.files.get('image', '')
    type_article_id = request.form.get('type_article_id', '')

    if poids_moyen == '':
        poids_moyen = None
    if taille == '':
        taille = None
    if longueur_vie == '':
        longueur_vie = None

    if image:
        filename = 'img_upload'+ str(int(2147483647 * random())) + '.png'
        image.save(os.path.join('static/images/', filename))
    else:
        print("erreur, image non prise en compte")
        filename=None

    sql = ''' INSERT INTO espece_animal(nom_espece, prix, poids_moyen, taille, longueur_vie, description, image, categorie_animal_id) VALUES
                                       (%s,         %s,   %s,          %s,      %s,          %s,          %s,    %s);'''
    tuple_add = (nom, prix, poids_moyen, taille, longueur_vie, description, filename, type_article_id)
    print(tuple_add)
    mycursor.execute(sql, tuple_add)

    get_db().commit()

    print(u'article ajouté , nom: ', nom, ' - type_article:', type_article_id, ' - prix:', prix,
          ' - description:', description, ' - image:', image)
    message = u'article ajouté , nom:' + nom + '- type_article:' + type_article_id + ' - prix:' + prix + ' - description:' + description + ' - image:' + str(
        image)
    flash(message, 'alert-success')
    return redirect('/admin/article/show')


@admin_article.route('/admin/article/delete', methods=['GET'])
def delete_article():
    id_article=request.args.get('id_article')
    mycursor = get_db().cursor()

    sql = ''' SELECT COUNT(DISTINCT id_variante) AS nb_declinaison FROM variante WHERE espece_animal_id = %s;'''
    mycursor.execute(sql, id_article)
    nb_declinaison = mycursor.fetchone()

    if nb_declinaison['nb_declinaison'] > 0:
        message= u'il y a des declinaisons dans cet article : vous ne pouvez pas le supprimer'
        flash(message, 'alert-warning')
    else:
        sql = ''' SELECT * FROM espece_animal WHERE id_espece_animal = %s; '''
        mycursor.execute(sql, id_article)
        article = mycursor.fetchone()
        print(article)
        image = article['image']

        sql = ''' DELETE FROM variante WHERE espece_animal_id = %s; '''
        mycursor.execute(sql, id_article)

        sql = ''' DELETE FROM espece_animal WHERE id_espece_animal = %s; '''
        mycursor.execute(sql, id_article)

        get_db().commit()

        if image != None:
            os.remove('static/images/' + image)

        print("un article supprimé, id :", id_article)
        message = u'un article supprimé, id : ' + id_article
        flash(message, 'alert-success')

    return redirect('/admin/article/show')


@admin_article.route('/admin/article/edit', methods=['GET'])
def edit_article():
    id_article=request.args.get('id_article')
    mycursor = get_db().cursor()

    sql = ''' SELECT id_espece_animal AS id_article,
                     nom_espece AS nom,
                     prix,
                     poids_moyen,
                     taille,
                     longueur_vie,
                     image,
                     description,
                     categorie_animal_id AS id_type_article
                     FROM espece_animal WHERE id_espece_animal = %s; '''
    mycursor.execute(sql, id_article)
    article = mycursor.fetchone()

    sql = ''' SELECT id_categorie_animal AS id_type_article, 
                         nom_categorie AS libelle
                         FROM categorie_animal;'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = ''' SELECT id_couleur,
                     nom_couleur AS libelle_couleur, 
                     id_variante AS id_declinaison_article,
                     espece_animal_id AS id_declinaison_article, 
                     stock
                      
                     FROM variante
                     JOIN couleur ON couleur.id_couleur = variante.couleur_id
                     
                     WHERE espece_animal_id = %s;
                      '''
    mycursor.execute(sql, id_article)
    declinaisons_article = mycursor.fetchall()

    return render_template('admin/article/edit_article.html'
                           ,article=article
                           ,types_article=types_article
                           ,declinaisons_article = declinaisons_article
                           )


@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    id_article = request.form.get('id_article')
    nom = request.form.get('nom', '')
    prix = request.form.get('prix', '')
    poids_moyen = request.form.get('poids_moyen', '')
    taille = request.form.get('taille', '')
    longueur_vie = request.form.get('longueur_vie', '')
    description = request.form.get('description', '')
    image = request.files.get('image', '')
    type_article_id = request.form.get('type_article_id', '')

    if poids_moyen == '':
        poids_moyen = None
    if taille == '':
        taille = None
    if longueur_vie == '':
        longueur_vie = None

    mycursor = get_db().cursor()

    sql = ''' SELECT image FROM espece_animal WHERE id_espece_animal = %s; '''
    mycursor.execute(sql, (id_article,))
    result = mycursor.fetchone()
    image_nom = result['image'] if result else None

    if image:
        if image_nom != "" and image_nom is not None and os.path.exists(
                os.path.join(os.getcwd() + "/static/images/", image_nom)):
            os.remove(os.path.join(os.getcwd() + "/static/images/", image_nom))
        # filename = secure_filename(image.filename)
        if image:
            filename = 'img_upload_' + str(int(2147483647 * random())) + '.png'
            image.save(os.path.join('static/images/', filename))
            image_nom = filename

    sql = '''  UPDATE espece_animal SET nom_espece=%s, prix=%s, poids_moyen=%s, taille=%s, longueur_vie=%s, description=%s, image=%s, categorie_animal_id=%s WHERE id_espece_animal=%s; '''
    mycursor.execute(sql, (nom, prix, poids_moyen, taille, longueur_vie, description, image_nom, type_article_id, id_article))

    get_db().commit()
    if image_nom is None:
        image_nom = ''
    message = u'article modifié , nom:' + nom + '- type_article :' + type_article_id + ' - prix:' + prix  + ' - image:' + image_nom + ' - description: ' + description
    flash(message, 'alert-success')
    return redirect('/admin/article/show')







@admin_article.route('/admin/article/avis/<int:id>', methods=['GET'])
def admin_avis(id):
    mycursor = get_db().cursor()
    article=[]
    commentaires = {}
    return render_template('admin/article/show_avis.html'
                           , article=article
                           , commentaires=commentaires
                           )


@admin_article.route('/admin/comment/delete', methods=['POST'])
def admin_avis_delete():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    userId = request.form.get('idUser', None)

    return admin_avis(article_id)
