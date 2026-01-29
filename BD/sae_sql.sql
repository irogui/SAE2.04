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

INSERT INTO categorie_animal (nom_categorie) VALUES
('Animal terrestre'),
('Animal aérien'),
('Animal aquatique'),
('Animal amphibie'),
('Animal reptile');

INSERT INTO couleur (nom_couleur) VALUES
('Rouge'), ('Blanc'), ('Noir'), ('Jaune'), ('Vert'), ('Bleu'), ('Orange'), ('Marron');

INSERT INTO etat (libelle_etat) VALUES
('En attente'), ('Payée'), ('Expédiée'), ('Livrée'), ('Annulée');

INSERT INTO utilisateur (login, email, password, role) VALUES
('admin', 'admin@', 'scrypt:32768:8:1$Ml2pV0qHPO9MleKy$a74be53606579df68da2f22ac167ab3dc8ad3bd34df1383634857442a4069a0994bc81bf771b4c8060174dd4ec7676445a33408e10dfacdeb39fffb6e230d7dd', 'ROLE_admin'),
('client1', 'client1@', 'scrypt:32768:8:1$jiguhX3syLyTCCNi$613fc1ef298afc2f5e5e978e0cc7a0f96c17615695348b276dc4cf1e4147711cb2af27ae595eafb560a9554962e64a1c71af8d2a85e7c53f78bf848aec7a7618', 'ROLE_client'),
('client2', 'client2@', 'scrypt:32768:8:1$c1vKyox517ZmFLC5$615b4fce3a1e31cb711077be5ab2f55b792d2d868d6fc51e0767b4bdfbafb08bf1875d26038786be3cb55e9f5bb5514e2f9b10d2b314a17a25a362ba1ac32902', 'ROLE_client');

INSERT INTO commande (date_achat, etat_id) VALUES
('2024-01-10', 2),
('2024-01-15', 3),
('2024-01-20', 1);

INSERT INTO classification (espece_animal_id, categorie_animal_id) VALUES
(1,3),(2,3),(3,3),(9,3),(13,3),(17,3),(18,3),
(4,1),(5,1),(6,1),(16,1),
(7,2),(8,2),(15,2),
(10,4),(14,4),
(11,5),(12,5);

INSERT INTO coloration (espece_animal_id, couleur_id) VALUES
(1,1),(1,7),(2,6),(3,1),(4,8),(6,2),(7,4),(8,6),(11,8),(12,3);

INSERT INTO ligne_commande (espece_animal_id, commande_id, prix, quantite) VALUES
(1,1,5.00,2),
(4,1,20.00,1),
(7,2,30.00,1),
(11,3,50.00,1);

INSERT INTO ligne_panier (espece_animal_id, utilisateur_id, quantite, date_ajout) VALUES
(3,2,1,'2024-01-25'),
(6,2,1,'2024-01-25'),
(8,3,1,'2024-01-26');