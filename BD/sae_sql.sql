DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS coloration;
DROP TABLE IF EXISTS classification;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS categorie_animal;
DROP TABLE IF EXISTS espece_animal;


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
);

CREATE TABLE categorie_animal(
   id_categorie_animal INT AUTO_INCREMENT,
   nom_categorie VARCHAR(100),

   PRIMARY KEY(id_categorie_animal)
);

CREATE TABLE couleur(
   id_couleur INT AUTO_INCREMENT,
   nom_couleur VARCHAR(50),

   PRIMARY KEY(id_couleur)
);

CREATE TABLE utilisateur(
   id_utilisateur INT AUTO_INCREMENT,
   login VARCHAR(100),
   email VARCHAR(255),
   nom_utilisateur VARCHAR(255),
   password VARCHAR(255),
   role VARCHAR(255),

   PRIMARY KEY(id_utilisateur)
);

CREATE TABLE etat(
   id_etat INT AUTO_INCREMENT,
   libelle_etat VARCHAR(100),

   PRIMARY KEY(id_etat)
);

CREATE TABLE commande(
   id_commande INT AUTO_INCREMENT,
   date_achat DATE,
   etat_id INT NOT NULL,

   PRIMARY KEY(id_commande),
   FOREIGN KEY(etat_id) REFERENCES etat(id_etat)
);

CREATE TABLE classification(
   espece_animal_id INT,
   categorie_animal_id INT,

   PRIMARY KEY(espece_animal_id, categorie_animal_id),
   FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
   FOREIGN KEY(categorie_animal_id) REFERENCES categorie_animal(id_categorie_animal)
);

CREATE TABLE coloration(
   espece_animal_id INT,
   couleur_id INT,

   PRIMARY KEY(espece_animal_id, couleur_id),
   FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
   FOREIGN KEY(couleur_id) REFERENCES couleur(id_couleur)
);

CREATE TABLE ligne_commande(
   espece_animal_id INT,
   commande_id INT,
   prix DECIMAL(15,2),
   quantite INT,

   PRIMARY KEY(espece_animal_id, commande_id),
   FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
   FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
);

CREATE TABLE ligne_panier(
   espece_animal_id INT,
   utilisateur_id INT,
   quantite INT,
   date_ajout DATE,

   PRIMARY KEY(espece_animal_id, utilisateur_id),
   FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
   FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);


INSERT INTO espece_animal (nom_espece, prix, poids_moyen, temperament, taille, longueur_vie, habitat, regime_alimentaire, sociable, description, photo) VALUES
('Argentavis', 2500000.00, 80.00, 'Indépendant', 7.00, 20, 'Pampas - Amérique du Sud', 'Carnivore nécrophage', false, 'Immense oiseau volant du Miocène, envergure jusqu''à ~7 m. Très grand planeur.','argentavis.png'),
('Achatina', 50.00, 0.50, 'Passif', 0.15, 10, 'Marais / sol humide', 'Herbivore', true, 'Grosse escargot terrestre.', 'achatina.png'),
('Lymantria', 30.00, 0.02, 'Passif', 0.05, 1, 'Zones boisées', 'Herbivore', true, 'Papillon de nuit produisant des spores.', 'lymantria.png'),
('Vautour', 1500.00, 7.00, 'Scavenger', 1.20, 30, 'Déserts / plaines', 'Nécrophage', false, 'Vautour charognard (genre de grands oiseaux).', 'vulture.png'),
('Deinosuchus', 1500000.00, 5000.00, 'Agressif', 12.00, 50, 'Rivières / marécages', 'Carnivore', false, 'Crocodilien géant préhistorique, jusqu''à 12–15 m.', 'deinosuchus.png'),
('Piranha', 200.00, 1.00, 'Agressif en banc', 0.40, 10, 'Eaux douces tropicales', 'Carnivore', true, 'Poisson d’eau douce carnivore.', 'piranha.png'),
('Beelzebufo', 120000.00, 4.50, 'Agressif', 0.40, 8, 'Zones humides tropicales', 'Carnivore', false, 'Grenouille géante préhistorique.', 'beelzebufo.png'),
('Kairuku', 800.00, 30.00, 'Colonial', 1.10, 25, 'Côtes froides', 'Piscivore', true, 'Manchots géants fossiles (genre Kairuku).', 'kairuku.png'),
('Gigantopithèque', 400000.00, 300.00, 'Timide', 3.00, 30, 'Forêts tropicales', 'Herbivore', true, 'Grand singe éteint d’Asie.', 'gigantopithecus.png'),
('Megaloceros', 100000.00, 500.00, 'Paixful', 2.10, 20, 'Prairies / forêts', 'Herbivore', true, 'Grand cerf aux bois immenses.', 'megaloceros.png'),
('Smilodon', 250000.00, 230.00, 'Agressif', 1.50, 20, 'Plaines / forêts', 'Carnivore', false, 'Grand félidé à dents de sabre.', 'sabertooth.png'),
('Thylacoléo', 300000.00, 120.00, 'Solitaire', 1.30, 18, 'Forêts / savanes', 'Carnivore', false, 'Carnivore marsupial puissant.', 'thylacoleo.png'),
('Titanoboa', 1800000.00, 1400.00, 'Agressif', 15.00, 25, 'Forêts humides', 'Carnivore', false, 'Serpent géant du Paléocène mesurant jusqu''à ~15 m.', 'titanoboa.png'),
<<<<<<< HEAD
('Mesopithèque', 900.00, 6.00, 'Sociable', 0.50, 15, 'Forêts / montagnes', 'Omnivore', true, 'Petit singe préhistorique.', 'mesopithecus.png'),
('Euryptéride', 5000.00, 5.00, 'Semi-agressif', 1.20, 5, 'Eaux peu profondes', 'Carnivore', false, 'Eurypteride, arthropode marin préhistorique.', 'eurypterid.png'),
('Ours', 120000.00, 600.00, 'Agressif', 2.80, 25, 'Forêts / montagnes froides', 'Omnivore', false, 'Ours géant du Pléistocène. ', 'dire_bear.png'),
('Cheval', 15000.00, 400.00, 'Docile', 1.60, 25, 'Prairies / steppes', 'Herbivore', true,'Genre regroupant les chevaux, ânes et zèbres. Apparue il y a ~4 millions d’années. Animal rapide, social et endurant, largement domestiqué par l’homme.', 'equus.png');

INSERT INTO categorie_animal(nom_categorie) VALUES
('Terrestre'),
('Aérien'),
('Marin');
=======
('Mesopithecus', 900.00, 6.00, 'Sociable', 0.50, 15, 'Forêts / montagnes', 'Omnivore', true, 'Petit singe préhistorique.', 'mesopithecus.png'),
('Eurypterid', 5000.00, 5.00, 'Semi-agressif', 1.20, 5, 'Eaux peu profondes', 'Carnivore', false, 'Eurypteride, arthropode marin préhistorique.', 'eurypterid.png'),
('Dire Bear', 120000.00, 600.00, 'Agressif', 2.80, 25, 'Forêts / montagnes froides', 'Omnivore', false, 'Ours géant du Pléistocène. ', 'dire_bear.png'),
('Cheval', 15000.00, 400.00, 'Docile', 1.60, 25, 'Prairies / steppes', 'Herbivore', true,'Genre regroupant les chevaux, ânes et zèbres. Apparue il y a ~4 millions d’années. Animal rapide, social et endurant, largement domestiqué par l’homme.', 'equus.png'
);
>>>>>>> 6da60ca70d85388e3c28dbf3cb2c2e0091c6eeee
