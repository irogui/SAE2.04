#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import *
import datetime
from decimal import *
from connexion_db import get_db

fixtures_load = Blueprint('fixtures_load', __name__,
                        template_folder='templates')

@fixtures_load.route('/base/init')
def fct_fixtures_load():
    mycursor = get_db().cursor()
    sql='''DROP TABLE IF EXISTS ligne_panier, ligne_commande, coloration, classification, commande, etat, utilisateur, couleur, categorie_animal, espece_animal;
'''

    mycursor.execute(sql)
    sql='''
    CREATE TABLE espece_animal(
       id_espece_animal INT AUTO_INCREMENT,
       nom_espece VARCHAR(100),
       prix DECIMAL(15,2),
       poids_moyen DECIMAL(15,2),
       temperament VARCHAR(50),
       taille DECIMAL(15,2),
       longueur_vie INT,
       habitat VARCHAR(100),
       regime_alimentaire VARCHAR(50),
       sociable BOOLEAN,
       description VARCHAR(8000),
       photo VARCHAR(255),
    
       PRIMARY KEY(id_espece_animal)
    ) DEFAULT CHARSET=utf8;
    '''
    mycursor.execute(sql)
    sql=''' 
INSERT INTO espece_animal (nom_espece, prix, poids_moyen, temperament, taille, longueur_vie, habitat, regime_alimentaire, sociable, description, photo) VALUES
    ('Poisson rouge', 5.00, 0.05, 'Paisible', 0.10, 5, 'Aquarium', 'Omnivore', true, 'Petit poisson d’eau douce très populaire en aquarium.', 'poisson_rouge.png'),
    ('Guppy', 3.00, 0.01, 'Actif', 0.04, 2, 'Aquarium', 'Omnivore', true, 'Poisson tropical très coloré et facile à élever.', 'guppy.png'),
    ('Betta', 8.00, 0.03, 'Territorial', 0.06, 3, 'Aquarium', 'Carnivore', false, 'Poisson combattant aux couleurs vives.', 'betta.png'),
    ('Hamster', 20.00, 0.15, 'Curieux', 0.12, 3, 'Cage', 'Omnivore', true, 'Petit rongeur nocturne.', 'hamster.png'),
    ('Cochon d’Inde', 25.00, 0.80, 'Docile', 0.25, 5, 'Cage', 'Herbivore', true, 'Rongeur sociable.', 'cochon_indie.png'),
    ('Lapin', 40.00, 2.50, 'Calme', 0.40, 8, 'Clapier / maison', 'Herbivore', true, 'Mammifère herbivore domestique.', 'lapin.png'),
    ('Canari', 30.00, 0.02, 'Chantant', 0.15, 10, 'Cage', 'Granivore', true, 'Oiseau chanteur.', 'canari.png'),
    ('Perroquet', 150.00, 0.90, 'Intelligent', 0.35, 50, 'Cage / volière', 'Omnivore', true, 'Oiseau coloré et bavard.', 'perroquet.png'),
    ('Tortue de Floride', 100.00, 1.50, 'Calme', 0.25, 30, 'Aquarium / bassin', 'Omnivore', true, 'Tortue aquatique.', 'tortue_floride.png'),
    ('Axolotl', 60.00, 0.15, 'Tranquille', 0.20, 15, 'Aquarium', 'Carnivore', true, 'Amphibien aquatique.', 'axolotl.png'),
    ('Gecko léopard', 50.00, 0.06, 'Sociable', 0.20, 15, 'Terrarium', 'Carnivore', true, 'Petit lézard nocturne.', 'gecko_leopard.png'),
    ('Serpent des blés', 80.00, 0.50, 'Docile', 1.20, 20, 'Terrarium', 'Carnivore', true, 'Serpent non venimeux.', 'serpent_ble.png'),
    ('Poisson combattant', 7.00, 0.02, 'Agressif', 0.06, 3, 'Aquarium', 'Carnivore', false, 'Poisson solitaire.', 'poisson_combattant.png'),
    ('Crapaud africain', 15.00, 0.20, 'Calme', 0.12, 10, 'Terrarium / aquarium', 'Omnivore', true, 'Amphibien robuste.', 'crapaud_africain.png'),
    ('Calopsitte', 90.00, 0.10, 'Sociable', 0.30, 20, 'Cage / volière', 'Granivore', true, 'Oiseau australien.', 'calopsitte.png'),
    ('Rat domestique', 12.00, 0.30, 'Intelligent', 0.25, 3, 'Cage', 'Omnivore', true, 'Rongeur très sociable.', 'rat.png'),
    ('Poisson néon', 2.50, 0.01, 'Paisible', 0.03, 3, 'Aquarium', 'Omnivore', true, 'Petit poisson coloré.', 'neon.png'),
    ('Perche soleil', 5.00, 0.10, 'Calme', 0.10, 6, 'Aquarium', 'Omnivore', true, 'Poisson d’eau douce.', 'perche_soleil.png');
    '''
    mycursor.execute(sql)

    sql=''' 
    CREATE TABLE categorie_animal(
       id_categorie_animal INT AUTO_INCREMENT,
       nom_categorie VARCHAR(100),
    
       PRIMARY KEY(id_categorie_animal)
    ) DEFAULT CHARSET=utf8;
    '''
    mycursor.execute(sql)
    sql=''' 
INSERT INTO categorie_animal (nom_categorie) VALUES
    ('Animal terrestre'),
    ('Animal aérien'),
    ('Animal aquatique'),
    ('Animal amphibie'),
    ('Animal reptile');
    '''
    mycursor.execute(sql)


    sql=''' 
    CREATE TABLE couleur(
       id_couleur INT AUTO_INCREMENT,
       nom_couleur VARCHAR(50),
    
       PRIMARY KEY(id_couleur)
    )  DEFAULT CHARSET=utf8;  
    '''
    mycursor.execute(sql)
    sql = '''
INSERT INTO couleur (nom_couleur) VALUES
    ('Rouge'),
    ('Blanc'),
    ('Noir'),
    ('Jaune'),
    ('Vert'),
    ('Bleu'),
    ('Orange'),
    ('Marron');
        '''
    mycursor.execute(sql)

    sql = ''' 
    CREATE TABLE utilisateur(
       id_utilisateur INT AUTO_INCREMENT,
       login VARCHAR(100),
       email VARCHAR(255),
       nom_utilisateur VARCHAR(255),
       password VARCHAR(255),
       role VARCHAR(255),
    
       PRIMARY KEY(id_utilisateur)
    )  DEFAULT CHARSET=utf8;  
     '''
    mycursor.execute(sql)
#    sql = '''
#    INSERT INTO utilisateur ()
#         '''
#    mycursor.execute(sql)

    sql = ''' 
    CREATE TABLE etat(
       id_etat INT AUTO_INCREMENT,
       libelle_etat VARCHAR(100),
    
       PRIMARY KEY(id_etat)
    ) DEFAULT CHARSET=utf8;  
     '''
    mycursor.execute(sql)
#    sql = '''
#    INSERT INTO etat()
#                 '''
#    mycursor.execute(sql)

    sql = '''
    CREATE TABLE commande(
       id_commande INT AUTO_INCREMENT,
       date_achat DATE,
       etat_id INT NOT NULL,
    
       PRIMARY KEY(id_commande),
       FOREIGN KEY(etat_id) REFERENCES etat(id_etat)
    ) DEFAULT CHARSET=utf8;
          '''
    mycursor.execute(sql)
#    sql = '''
#          INSERT INTO commande()
#          '''
#    mycursor.execute(sql)

    sql = '''
    CREATE TABLE classification(
       espece_animal_id INT,
       categorie_animal_id INT,
    
       PRIMARY KEY(espece_animal_id, categorie_animal_id),
       FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
       FOREIGN KEY(categorie_animal_id) REFERENCES categorie_animal(id_categorie_animal)
    ) DEFAULT CHARSET=utf8;
          '''
    mycursor.execute(sql)
#    sql = '''
#          INSERT INTO classification()
#          '''
#    mycursor.execute(sql)

    sql = '''
    CREATE TABLE coloration(
       espece_animal_id INT,
       couleur_id INT,
    
       PRIMARY KEY(espece_animal_id, couleur_id),
       FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
       FOREIGN KEY(couleur_id) REFERENCES couleur(id_couleur)
    ) DEFAULT CHARSET=utf8;
          '''
    mycursor.execute(sql)
#    sql = '''
#          INSERT INTO coloration()
#          '''
#    mycursor.execute(sql)

    sql = ''' 
    CREATE TABLE ligne_commande(
       espece_animal_id INT,
       commande_id INT,
       prix DECIMAL(15,2),
       quantite INT,
    
       PRIMARY KEY(espece_animal_id, commande_id),
       FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
       FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
    ) DEFAULT CHARSET=utf8;
         '''
    mycursor.execute(sql)
#    sql = '''
#    INSERT INTO ligne_commande()
#          '''
#    mycursor.execute(sql)


    sql = ''' 
    CREATE TABLE ligne_panier(
       espece_animal_id INT,
       utilisateur_id INT,
       quantite INT,
       date_ajout DATE,
    
       PRIMARY KEY(espece_animal_id, utilisateur_id),
       FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
       FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
    );  
         '''
    mycursor.execute(sql)


    get_db().commit()
    return redirect('/')
