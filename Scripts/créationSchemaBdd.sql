---- Création de la base de données

CREATE DATABASE tifosi
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE tifosi;

-- Création de l'utilisateur tifosi et de ses privilèges

CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'tifosi';

GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';

FLUSH PRIVILEGES;

---- Création des tables de la base de données
-- Table Ingrdient

CREATE TABLE ingredient (
    id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

-- Table Marque 

CREATE TABLE marque (
    id_marque INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

-- Table Boisson

CREATE TABLE boisson (
    id_boisson INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    id_marque INT NOT NULL,

    CONSTRAINT fk_boisson_marque
    FOREIGN KEY (id_marque)
    REFERENCES marque(id_marque)
);

--Table Focaccia

CREATE TABLE focaccia (
    id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    prix DECIMAL(5,2) NOT NULL CHECK (prix > 0)
);

-- Table Menu 

CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) NOT NULL CHECK (prix > 0),
    id_focaccia INT NOT NULL,

    CONSTRAINT fk_menu_focaccia
    FOREIGN KEY (id_focaccia)
    REFERENCES focaccia(id_focaccia)
);

-- Table Client

CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    code_postal INT NOT NULL
);

---- Relations entre les tables
-- Table Achete

CREATE TABLE achete (
    id_client INT,
    id_menu INT,
    date_achat DATE NOT NULL,

    PRIMARY KEY (id_client, id_menu, date_achat),

    FOREIGN KEY (id_client)
    REFERENCES client(id_client),

    FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu)
);

--Table Comprend

CREATE TABLE comprend (
    id_focaccia INT,
    id_ingredient INT,
    quantite INT NOT NULL CHECK (quantite > 0),

    PRIMARY KEY (id_focaccia, id_ingredient),

    FOREIGN KEY (id_focaccia)
    REFERENCES focaccia(id_focaccia),

    FOREIGN KEY (id_ingredient)
    REFERENCES ingredient(id_ingredient)
);

--Table Contient

CREATE TABLE contient (
    id_menu INT,
    id_boisson INT,

    PRIMARY KEY (id_menu, id_boisson),

    FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu),

    FOREIGN KEY (id_boisson)
    REFERENCES boisson(id_boisson)
);

