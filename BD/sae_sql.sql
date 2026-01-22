DROP TABLE IF EXISTS membre;
DROP TABLE IF EXISTS apparition;
DROP TABLE IF EXISTS espece;
DROP TABLE IF EXISTS carte;
DROP TABLE IF EXISTS boutique;


CREATE TABLE membre(
    id_membre INT AUTO_INCREMENT,
    nomMembre VARCHAR(25),
    idDiscord VARCHAR(25),
    gold INT,
    codeCoffre VARCHAR(4),
    daily BOOLEAN,

    PRIMARY KEY (id_membre)
);

CREATE TABLE boutique(
    id_boutique INT AUTO_INCREMENT,
    cooBoutique VARCHAR(5),

    PRIMARY KEY(id_boutique)
);

CREATE TABLE carte(
    id_carte INT AUTO_INCREMENT,
    nomCarte VARCHAR(25),
    boutique_id INT,

    PRIMARY KEY(id_carte),
    FOREIGN KEY(boutique_id) REFERENCES boutique(id_boutique)
);

CREATE TABLE espece(
    id_espece INT AUTO_INCREMENT,
    nomEspece VARCHAR(20),
    prixEspece INT,
    biomeEspece VARCHAR(250),
    tempEspece VARCHAR(250)

    PRIMARY KEY(id_espece)
);

CREATE TABLE apparition(
    espece_id INT,
    carte_id INT,

    PRIMARY KEY (espece_id, carte_id),
    FOREIGN KEY (carte_id) REFERENCES carte(id_carte),
    FOREIGN KEY (espece_id) REFERENCES espece(id_espece)
);


INSERT INTO membre(nomMembre, idDiscord, gold, codeCoffre, daily) VALUES
("Izaar", "123456789", 950, "0912", True),
("Golden", "097654321", 1304, "1324", False);

INSERT INTO boutique(cooBoutique) VALUES
("50/50");

INSERT INTO carte(nomCarte, boutique_id) VALUES
("Midgard(Fjordur)", 1);

INSERT INTO espece(nomEspece, prixEspece, biomeEspece) VALUES
("Andrewsarchus",650, "fjord");

INSERT INTO apparition(espece_id, carte_id) VALUES
(1, 1);