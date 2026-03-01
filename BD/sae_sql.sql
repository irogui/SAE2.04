DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS variante;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS espece_animal;
DROP TABLE IF EXISTS categorie_animal;


CREATE TABLE categorie_animal(
    id_categorie_animal INT AUTO_INCREMENT,
    nom_categorie VARCHAR(100),

    PRIMARY KEY(id_categorie_animal)
);

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
    image VARCHAR(255),
    categorie_animal_id INT,

    PRIMARY KEY(id_espece_animal),
    FOREIGN KEY (categorie_animal_id) REFERENCES categorie_animal(id_categorie_animal)
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
    etat_id INT,
    utilisateur_id INT,

    PRIMARY KEY(id_commande),
    FOREIGN KEY(etat_id) REFERENCES etat(id_etat),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE variante(
    id_variante INT AUTO_INCREMENT,
    espece_animal_id INT,
    couleur_id INT,
    stock INT,

    PRIMARY KEY(id_variante),
    FOREIGN KEY(espece_animal_id) REFERENCES espece_animal(id_espece_animal),
    FOREIGN KEY(couleur_id) REFERENCES couleur(id_couleur)
);

CREATE TABLE ligne_commande(
    variante_id INT,
    commande_id INT,
    prix_commande DECIMAL(15,2),
    quantite INT,

    PRIMARY KEY(variante_id, commande_id),
    FOREIGN KEY(variante_id) REFERENCES variante(id_variante),
    FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
);

CREATE TABLE ligne_panier(
    variante_id INT,
    utilisateur_id INT,
    quantite INT,
    date_ajout DATE,

    PRIMARY KEY(variante_id, utilisateur_id),
    FOREIGN KEY(variante_id) REFERENCES variante(id_variante),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);


INSERT INTO categorie_animal (nom_categorie) VALUES
('Poisson'),
('Mammifère'),
('Oiseau'),
('Reptile'),
('Amphibien');

INSERT INTO espece_animal(nom_espece, prix, poids_moyen, temperament, taille, longueur_vie, habitat, regime_alimentaire, sociable, description, image, categorie_animal_id) VALUES
('Poisson rouge', 3.00, 0.10, 'Paisible', 10, 10, 'Aquarium', 'Omnivore', TRUE, 'Poisson d’eau douce très populaire.', 'poisson_rouge.png', 1),
('Guppy', 2.50, 0.04, 'Actif', 5, 3, 'Aquarium', 'Omnivore', TRUE, 'Petit poisson tropical coloré.', 'guppy.png', 1),
('Betta', 12.00, 0.06, 'Territorial', 4, 4, 'Aquarium', 'Carnivore', FALSE, 'Poisson combattant solitaire.', 'betta.png', 1),
('Hamster', 15.00, 0.12, 'Curieux', 3, 2, 'Cage', 'Omnivore', TRUE, 'Petit rongeur nocturne.', 'hamster.png', 2),
('Cochon d’Inde', 35.00, 0.25, 'Docile', 5, 6, 'Cage', 'Herbivore', TRUE, 'Rongeur sociable.', 'cochon_inde.png', 5),
('Lapin', 60.00, 0.40, 'Calme', 8, 9, 'Maison / clapier', 'Herbivore', TRUE, 'Mammifère herbivore domestique.', 'lapin.png', 2),
('Canari', 25.00, 0.15, 'Chantant', 10, 10, 'Cage', 'Granivore', TRUE, 'Petit oiseau chanteur.', 'canari.png', 3),
('Perroquet', 250.00, 0.35, 'Intelligent', 50, 50, 'Volière', 'Omnivore', TRUE, 'Oiseau très intelligent.', 'perroquet.png', 3),
('Tortue de Floride', 80.00, 0.25, 'Calme', 30, 30, 'Aquarium / bassin', 'Omnivore', TRUE, 'Tortue aquatique.', 'tortue_floride.png', 4),
('Axolotl', 40.00, 0.20, 'Tranquille', 15, 15, 'Aquarium', 'Carnivore', TRUE, 'Amphibien aquatique.', 'axolotl.png', 5),
('Gecko léopard', 50.00, 0.20, 'Sociable', 15, 20, 'Terrarium', 'Carnivore', TRUE, 'Lézard nocturne.', 'gecko_leopard.png', 4),
('Serpent des blés', 90.00, 1.20, 'Docile', 20, 15, 'Terrarium', 'Carnivore', TRUE, 'Serpent non venimeux.', 'serpent_ble.png', 4),
('Poisson combattant', 10.00, 0.06, 'Agressif', 3, 4, 'Aquarium', 'Carnivore', FALSE, 'Poisson solitaire.', 'poisson_combattant.png', 1),
('Crapaud africain', 30.00, 0.12, 'Calme', 10, 10, 'Terrarium', 'Omnivore', TRUE, 'Amphibien robuste.', 'crapaud_africain.png', 5),
('Calopsitte', 120.00, 0.30, 'Sociable', 20, 25, 'Volière', 'Granivore', TRUE, 'Oiseau australien.', 'calopsitte.png', 3),
('Rat domestique', 20.00, 0.25, 'Intelligent', 3, 3, 'Cage', 'Omnivore', TRUE, 'Rongeur très sociable.', 'rat.png', 2),
('Poisson néon', 2.00, 0.03, 'Paisible', 3, 5, 'Aquarium', 'Omnivore', TRUE, 'Petit poisson coloré.', 'neon.png', 1),
('Perche soleil', 15.00, 0.30, 'Vif', 7, 6, 'Aquarium', 'Carnivore', TRUE, 'Poisson d’eau douce.', 'perche_soleil.png', 1);

INSERT INTO couleur (nom_couleur) VALUES
('Rouge'), ('Blanc'), ('Noir'), ('Jaune'), ('Vert'), ('Bleu'), ('Orange'), ('Marron');

INSERT INTO utilisateur (login, email, password, role) VALUES
('admin', 'admin@', 'scrypt:32768:8:1$Ml2pV0qHPO9MleKy$a74be53606579df68da2f22ac167ab3dc8ad3bd34df1383634857442a4069a0994bc81bf771b4c8060174dd4ec7676445a33408e10dfacdeb39fffb6e230d7dd', 'ROLE_admin'),
('client1', 'client1@', 'scrypt:32768:8:1$jiguhX3syLyTCCNi$613fc1ef298afc2f5e5e978e0cc7a0f96c17615695348b276dc4cf1e4147711cb2af27ae595eafb560a9554962e64a1c71af8d2a85e7c53f78bf848aec7a7618', 'ROLE_client'),
('client2', 'client2@', 'scrypt:32768:8:1$c1vKyox517ZmFLC5$615b4fce3a1e31cb711077be5ab2f55b792d2d868d6fc51e0767b4bdfbafb08bf1875d26038786be3cb55e9f5bb5514e2f9b10d2b314a17a25a362ba1ac32902', 'ROLE_client');

INSERT INTO etat (libelle_etat) VALUES
('En attente'), ('Payée'), ('Expédiée'), ('Livrée'), ('Annulée');

INSERT INTO variante (espece_animal_id, couleur_id, stock) VALUES
-- Poisson rouge
(1,7,30),(1,1,20),(1,2,15),

-- Guppy
(2,6,40),(2,1,25),(2,4,20),

-- Betta
(3,1,15),(3,6,10),(3,3,8),

-- Hamster
(4,8,20),(4,2,15),(4,3,10),

-- Cochon d’Inde
(5,2,18),(5,8,12),

-- Lapin
(6,2,10),(6,3,8),(6,8,6),

-- Canari
(7,4,25),(7,2,15),

-- Perroquet
(8,5,6),(8,6,5),(8,1,4),

-- Tortue de Floride
(9,5,12),(9,3,8),

-- Axolotl
(10,2,10),(10,3,8),(10,1,6),

-- Gecko léopard
(11,8,15),(11,2,10),

-- Serpent des blés
(12,1,10),(12,7,6),(12,8,5),

-- Poisson combattant
(13,1,12),(13,6,8),

-- Crapaud africain
(14,5,14),(14,8,10),

-- Calopsitte
(15,4,10),(15,2,8),

-- Rat domestique
(16,3,20),(16,2,15),(16,8,10),

-- Poisson néon
(17,6,40),(17,1,20),

-- Perche soleil
(18,5,15),(18,4,10);

INSERT INTO ligne_panier (variante_id, utilisateur_id, quantite, date_ajout) VALUES
(3,2,5,'2024-01-25'),
(6,2,9,'2024-01-25'),
(8,3,1,'2024-01-26');


SELECT * FROM ligne_commande;