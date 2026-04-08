-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: TPAM
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorie_animal`
--

DROP TABLE IF EXISTS `categorie_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorie_animal` (
  `id_categorie_animal` int NOT NULL AUTO_INCREMENT,
  `nom_categorie` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_categorie_animal`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie_animal`
--

LOCK TABLES `categorie_animal` WRITE;
/*!40000 ALTER TABLE `categorie_animal` DISABLE KEYS */;
INSERT INTO `categorie_animal` VALUES (1,'Poisson'),(2,'Mammifère'),(3,'Oiseau'),(4,'Reptile'),(5,'Amphibien');
/*!40000 ALTER TABLE `categorie_animal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commande`
--

DROP TABLE IF EXISTS `commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commande` (
  `id_commande` int NOT NULL AUTO_INCREMENT,
  `date_achat` date DEFAULT NULL,
  `etat_id` int DEFAULT NULL,
  `utilisateur_id` int DEFAULT NULL,
  PRIMARY KEY (`id_commande`),
  KEY `etat_id` (`etat_id`),
  KEY `utilisateur_id` (`utilisateur_id`),
  CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`etat_id`) REFERENCES `etat` (`id_etat`),
  CONSTRAINT `commande_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateur` (`id_utilisateur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commande`
--

LOCK TABLES `commande` WRITE;
/*!40000 ALTER TABLE `commande` DISABLE KEYS */;
/*!40000 ALTER TABLE `commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commentaire`
--

DROP TABLE IF EXISTS `commentaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentaire` (
  `espece_animal_id` int NOT NULL,
  `utilisateur_id` int NOT NULL,
  `date_commenaite` datetime NOT NULL,
  `valider` tinyint(1) DEFAULT NULL,
  `commentaire` varchar(1023) DEFAULT NULL,
  PRIMARY KEY (`espece_animal_id`,`utilisateur_id`,`date_commenaite`),
  KEY `utilisateur_id` (`utilisateur_id`),
  CONSTRAINT `commentaire_ibfk_1` FOREIGN KEY (`espece_animal_id`) REFERENCES `espece_animal` (`id_espece_animal`),
  CONSTRAINT `commentaire_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateur` (`id_utilisateur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commentaire`
--

LOCK TABLES `commentaire` WRITE;
/*!40000 ALTER TABLE `commentaire` DISABLE KEYS */;
/*!40000 ALTER TABLE `commentaire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `couleur`
--

DROP TABLE IF EXISTS `couleur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `couleur` (
  `id_couleur` int NOT NULL AUTO_INCREMENT,
  `nom_couleur` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_couleur`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `couleur`
--

LOCK TABLES `couleur` WRITE;
/*!40000 ALTER TABLE `couleur` DISABLE KEYS */;
INSERT INTO `couleur` VALUES (1,'Rouge'),(2,'Blanc'),(3,'Noir'),(4,'Jaune'),(5,'Vert'),(6,'Bleu'),(7,'Orange'),(8,'Marron');
/*!40000 ALTER TABLE `couleur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `espece_animal`
--

DROP TABLE IF EXISTS `espece_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `espece_animal` (
  `id_espece_animal` int NOT NULL AUTO_INCREMENT,
  `nom_espece` varchar(100) DEFAULT NULL,
  `prix` decimal(15,2) DEFAULT NULL,
  `poids_moyen` decimal(15,2) DEFAULT NULL,
  `temperament` varchar(50) DEFAULT NULL,
  `taille` decimal(15,2) DEFAULT NULL,
  `longueur_vie` int DEFAULT NULL,
  `habitat` varchar(100) DEFAULT NULL,
  `regime_alimentaire` varchar(50) DEFAULT NULL,
  `sociable` tinyint(1) DEFAULT NULL,
  `description` varchar(8000) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `categorie_animal_id` int DEFAULT NULL,
  PRIMARY KEY (`id_espece_animal`),
  KEY `categorie_animal_id` (`categorie_animal_id`),
  CONSTRAINT `espece_animal_ibfk_1` FOREIGN KEY (`categorie_animal_id`) REFERENCES `categorie_animal` (`id_categorie_animal`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `espece_animal`
--

LOCK TABLES `espece_animal` WRITE;
/*!40000 ALTER TABLE `espece_animal` DISABLE KEYS */;
INSERT INTO `espece_animal` VALUES (1,'Poisson rouge',3.00,0.10,'Paisible',10.00,10,'Aquarium','Omnivore',1,'Poisson d’eau douce très populaire.','poisson_rouge.png',1),(2,'Guppy',2.50,0.04,'Actif',5.00,3,'Aquarium','Omnivore',1,'Petit poisson tropical coloré.','guppy.png',1),(3,'Betta',12.00,0.06,'Territorial',4.00,4,'Aquarium','Carnivore',0,'Poisson combattant solitaire.','betta.png',1),(4,'Hamster',15.00,0.12,'Curieux',3.00,2,'Cage','Omnivore',1,'Petit rongeur nocturne.','hamster.png',2),(5,'Cochon d’Inde',35.00,0.25,'Docile',5.00,6,'Cage','Herbivore',1,'Rongeur sociable.','cochon_inde.png',5),(6,'Lapin',60.00,0.40,'Calme',8.00,9,'Maison / clapier','Herbivore',1,'Mammifère herbivore domestique.','lapin.png',2),(7,'Canari',25.00,0.15,'Chantant',10.00,10,'Cage','Granivore',1,'Petit oiseau chanteur.','canari.png',3),(8,'Perroquet',250.00,0.35,'Intelligent',50.00,50,'Volière','Omnivore',1,'Oiseau très intelligent.','perroquet.png',3),(9,'Tortue de Floride',80.00,0.25,'Calme',30.00,30,'Aquarium / bassin','Omnivore',1,'Tortue aquatique.','tortue_floride.png',4),(10,'Axolotl',40.00,0.20,'Tranquille',15.00,15,'Aquarium','Carnivore',1,'Amphibien aquatique.','axolotl.png',5),(11,'Gecko léopard',50.00,0.20,'Sociable',15.00,20,'Terrarium','Carnivore',1,'Lézard nocturne.','gecko_leopard.png',4),(12,'Serpent des blés',90.00,1.20,'Docile',20.00,15,'Terrarium','Carnivore',1,'Serpent non venimeux.','serpent_ble.png',4),(13,'Poisson combattant',10.00,0.06,'Agressif',3.00,4,'Aquarium','Carnivore',0,'Poisson solitaire.','poisson_combattant.png',1),(14,'Crapaud africain',30.00,0.12,'Calme',10.00,10,'Terrarium','Omnivore',1,'Amphibien robuste.','crapaud_africain.png',5),(15,'Calopsitte',120.00,0.30,'Sociable',20.00,25,'Volière','Granivore',1,'Oiseau australien.','calopsitte.png',3),(16,'Rat domestique',20.00,0.25,'Intelligent',3.00,3,'Cage','Omnivore',1,'Rongeur très sociable.','rat.png',2),(17,'Poisson néon',2.00,0.03,'Paisible',3.00,5,'Aquarium','Omnivore',1,'Petit poisson coloré.','neon.png',1),(18,'Perche soleil',15.00,0.30,'Vif',7.00,6,'Aquarium','Carnivore',1,'Poisson d’eau douce.','perche_soleil.png',1);
/*!40000 ALTER TABLE `espece_animal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etat`
--

DROP TABLE IF EXISTS `etat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etat` (
  `id_etat` int NOT NULL AUTO_INCREMENT,
  `libelle_etat` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_etat`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etat`
--

LOCK TABLES `etat` WRITE;
/*!40000 ALTER TABLE `etat` DISABLE KEYS */;
INSERT INTO `etat` VALUES (1,'En attente'),(2,'Payée'),(3,'Expédiée'),(4,'Livrée'),(5,'Annulée');
/*!40000 ALTER TABLE `etat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ligne_commande`
--

DROP TABLE IF EXISTS `ligne_commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ligne_commande` (
  `variante_id` int NOT NULL,
  `commande_id` int NOT NULL,
  `prix_commande` decimal(15,2) DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  PRIMARY KEY (`variante_id`,`commande_id`),
  KEY `commande_id` (`commande_id`),
  CONSTRAINT `ligne_commande_ibfk_1` FOREIGN KEY (`variante_id`) REFERENCES `variante` (`id_variante`),
  CONSTRAINT `ligne_commande_ibfk_2` FOREIGN KEY (`commande_id`) REFERENCES `commande` (`id_commande`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligne_commande`
--

LOCK TABLES `ligne_commande` WRITE;
/*!40000 ALTER TABLE `ligne_commande` DISABLE KEYS */;
/*!40000 ALTER TABLE `ligne_commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ligne_panier`
--

DROP TABLE IF EXISTS `ligne_panier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ligne_panier` (
  `variante_id` int NOT NULL,
  `utilisateur_id` int NOT NULL,
  `quantite` int DEFAULT NULL,
  `date_ajout` date DEFAULT NULL,
  PRIMARY KEY (`variante_id`,`utilisateur_id`),
  KEY `utilisateur_id` (`utilisateur_id`),
  CONSTRAINT `ligne_panier_ibfk_1` FOREIGN KEY (`variante_id`) REFERENCES `variante` (`id_variante`),
  CONSTRAINT `ligne_panier_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateur` (`id_utilisateur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligne_panier`
--

LOCK TABLES `ligne_panier` WRITE;
/*!40000 ALTER TABLE `ligne_panier` DISABLE KEYS */;
/*!40000 ALTER TABLE `ligne_panier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note` (
  `espece_animal_id` int NOT NULL,
  `utilisateur_id` int NOT NULL,
  `note` decimal(1,1) DEFAULT NULL,
  PRIMARY KEY (`espece_animal_id`,`utilisateur_id`),
  KEY `utilisateur_id` (`utilisateur_id`),
  CONSTRAINT `note_ibfk_1` FOREIGN KEY (`espece_animal_id`) REFERENCES `espece_animal` (`id_espece_animal`),
  CONSTRAINT `note_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateur` (`id_utilisateur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `note`
--

LOCK TABLES `note` WRITE;
/*!40000 ALTER TABLE `note` DISABLE KEYS */;
/*!40000 ALTER TABLE `note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateur` (
  `id_utilisateur` int NOT NULL AUTO_INCREMENT,
  `login` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nom_utilisateur` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateur`
--

LOCK TABLES `utilisateur` WRITE;
/*!40000 ALTER TABLE `utilisateur` DISABLE KEYS */;
INSERT INTO `utilisateur` VALUES (1,'admin','admin@',NULL,'scrypt:32768:8:1$Ml2pV0qHPO9MleKy$a74be53606579df68da2f22ac167ab3dc8ad3bd34df1383634857442a4069a0994bc81bf771b4c8060174dd4ec7676445a33408e10dfacdeb39fffb6e230d7dd','ROLE_admin'),(2,'client1','client1@',NULL,'scrypt:32768:8:1$jiguhX3syLyTCCNi$613fc1ef298afc2f5e5e978e0cc7a0f96c17615695348b276dc4cf1e4147711cb2af27ae595eafb560a9554962e64a1c71af8d2a85e7c53f78bf848aec7a7618','ROLE_client'),(3,'client2','client2@',NULL,'scrypt:32768:8:1$c1vKyox517ZmFLC5$615b4fce3a1e31cb711077be5ab2f55b792d2d868d6fc51e0767b4bdfbafb08bf1875d26038786be3cb55e9f5bb5514e2f9b10d2b314a17a25a362ba1ac32902','ROLE_client');
/*!40000 ALTER TABLE `utilisateur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variante`
--

DROP TABLE IF EXISTS `variante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variante` (
  `id_variante` int NOT NULL AUTO_INCREMENT,
  `espece_animal_id` int DEFAULT NULL,
  `couleur_id` int DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `prix_declinaison` int DEFAULT NULL,
  `image` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id_variante`),
  KEY `espece_animal_id` (`espece_animal_id`),
  KEY `couleur_id` (`couleur_id`),
  CONSTRAINT `variante_ibfk_1` FOREIGN KEY (`espece_animal_id`) REFERENCES `espece_animal` (`id_espece_animal`),
  CONSTRAINT `variante_ibfk_2` FOREIGN KEY (`couleur_id`) REFERENCES `couleur` (`id_couleur`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variante`
--

LOCK TABLES `variante` WRITE;
/*!40000 ALTER TABLE `variante` DISABLE KEYS */;
INSERT INTO `variante` VALUES (1,1,7,30,NULL,NULL),(2,1,1,20,NULL,NULL),(3,1,2,15,NULL,NULL),(4,2,6,40,NULL,NULL),(5,2,1,25,NULL,NULL),(6,2,4,20,NULL,NULL),(7,3,1,15,NULL,NULL),(8,3,6,10,NULL,NULL),(9,3,3,8,NULL,NULL),(10,4,8,20,NULL,NULL),(11,4,2,15,NULL,NULL),(12,4,3,10,NULL,NULL),(13,5,2,18,NULL,NULL),(14,5,8,12,NULL,NULL),(15,6,2,10,NULL,NULL),(16,6,3,8,NULL,NULL),(17,6,8,6,NULL,NULL),(18,7,4,25,NULL,NULL),(19,7,2,15,NULL,NULL),(20,8,5,6,NULL,NULL),(21,8,6,5,NULL,NULL),(22,8,1,4,NULL,NULL),(23,9,5,12,NULL,NULL),(24,9,3,8,NULL,NULL),(25,10,2,10,NULL,NULL),(26,10,3,8,NULL,NULL),(27,10,1,6,NULL,NULL),(28,11,8,15,NULL,NULL),(29,11,2,10,NULL,NULL),(30,12,1,10,NULL,NULL),(31,12,7,6,NULL,NULL),(32,12,8,5,NULL,NULL),(33,13,1,12,NULL,NULL),(34,13,6,8,NULL,NULL),(35,14,5,14,NULL,NULL),(36,14,8,10,NULL,NULL),(37,15,4,10,NULL,NULL),(38,15,2,8,NULL,NULL),(39,16,3,20,NULL,NULL),(40,16,2,15,NULL,NULL),(41,16,8,10,NULL,NULL),(42,17,6,40,NULL,NULL),(43,17,1,20,NULL,NULL),(44,18,5,15,NULL,NULL),(45,18,4,10,NULL,NULL);
/*!40000 ALTER TABLE `variante` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08 16:54:01
