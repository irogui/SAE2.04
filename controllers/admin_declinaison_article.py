#! /usr/bin/python
# -*- coding:utf-8 -*-

from flask import Blueprint
from flask import request, render_template, redirect, flash
from connexion_db import get_db

admin_declinaison_article = Blueprint('admin_declinaison_article', __name__,
                         template_folder='templates')


@admin_declinaison_article.route('/admin/declinaison_article/add')
def add_declinaison_article():
    id_article = request.args.get('id_article')

    mycursor = get_db().cursor()

    sql = ''' SELECT id_espece_animal AS id_article,
                     image
                     FROM espece_animal
                     WHERE id_espece_animal = %s;'''
    mycursor.execute(sql, (id_article,))
    article = mycursor.fetchone()

    sql = ''' SELECT id_couleur,
                     nom_couleur AS libelle
                     FROM couleur;'''
    mycursor.execute(sql)
    couleurs = mycursor.fetchall()

    tailles=[]
    d_taille_uniq=None
    d_couleur_uniq=None

    return render_template('admin/article/add_declinaison_article.html'
                           , article=article
                           , couleurs=couleurs
                           , tailles=tailles
                           , d_taille_uniq=d_taille_uniq
                           , d_couleur_uniq=d_couleur_uniq
                           )


@admin_declinaison_article.route('/admin/declinaison_article/add', methods=['POST'])
def valid_add_declinaison_article():

    id_article = request.form.get('id_article')
    stock = request.form.get('stock')
    taille = request.form.get('taille')
    couleur = request.form.get('couleur')

    print(f"-{id_article}-{stock}-{couleur}-")

    mycursor = get_db().cursor()
    # attention au doublon

    sql = ''' SELECT id_variante FROM variante WHERE espece_animal_id=%s AND couleur_id=%s; '''
    mycursor.execute(sql, (id_article, couleur))
    variante = mycursor.fetchone()

    if variante:
        sql = ''' UPDATE variante SET stock=stock+%s WHERE id_variante=%s; '''
        mycursor.execute(sql, (stock, id_article))
    else:
        sql = ''' INSERT INTO variante(espece_animal_id, couleur_id, stock) VALUES (%s, %s, %s); '''
        mycursor.execute(sql, (id_article, couleur, stock))

    get_db().commit()
    return redirect('/admin/article/edit?id_article=' + id_article)


@admin_declinaison_article.route('/admin/declinaison_article/edit', methods=['GET'])
def edit_declinaison_article():
    id_declinaison_article = request.args.get('id_declinaison_article')

    mycursor = get_db().cursor()

    sql = ''' SELECT id_variante AS id_declinaison_article,
                     espece_animal_id AS article_id,
                     couleur_id AS id_couleur,
                     stock,
                     image AS image_article
                     FROM variante
                     JOIN espece_animal ON espece_animal.id_espece_animal = variante.espece_animal_id
                     WHERE id_variante = %s;'''
    mycursor.execute(sql, (id_declinaison_article,))
    declinaison_article = mycursor.fetchone()

    sql = ''' SELECT id_couleur,
                         nom_couleur AS libelle
                         FROM couleur;'''
    mycursor.execute(sql)
    couleurs = mycursor.fetchall()

    tailles=[]
    d_taille_uniq=None
    d_couleur_uniq=None
    return render_template('admin/article/edit_declinaison_article.html'
                           , tailles=tailles
                           , couleurs=couleurs
                           , declinaison_article=declinaison_article
                           , d_taille_uniq=d_taille_uniq
                           , d_couleur_uniq=d_couleur_uniq
                           )


@admin_declinaison_article.route('/admin/declinaison_article/edit', methods=['POST'])
def valid_edit_declinaison_article():
    id_declinaison_article = request.form.get('id_declinaison_article','')
    id_article = request.form.get('id_article','')
    stock = request.form.get('stock','')
    taille_id = request.form.get('id_taille','')
    couleur_id = request.form.get('id_couleur','')

    mycursor = get_db().cursor()

    sql = ''' UPDATE variante SET stock=%s, couleur_id=%s WHERE id_variante=%s; '''
    mycursor.execute(sql, (stock, couleur_id, id_article))
    get_db().commit()

    message = u'declinaison_article modifié , id:' + str(id_declinaison_article) + '- stock :' + str(stock) + ' - taille_id:' + str(taille_id) + ' - couleur_id:' + str(couleur_id)
    flash(message, 'alert-success')
    return redirect('/admin/article/edit?id_article=' + str(id_article))


@admin_declinaison_article.route('/admin/declinaison_article/delete', methods=['GET'])
def admin_delete_declinaison_article():
    id_declinaison_article = request.args.get('id_declinaison_article')
    id_article = request.args.get('id_article')

    #mycursor = get_db().cursor()
    #sql = ''' DELETE FROM variante WHERE id_variante = %s; '''
    #mycursor.execute(sql, (id_article,))
    #get_db().commit()

    flash(u'declinaison supprimée, id_declinaison_article : ' + str(id_declinaison_article),  'alert-success')
    return redirect('/admin/article/edit?id_article=' + str(id_article))
