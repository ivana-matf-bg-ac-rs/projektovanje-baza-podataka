/*
5. Data je šema relacione baze podataka za potrebe skladišta robe u toku jedne godine:

ROBA(SifR, Naziv, Opis, SifD);
DOBAVLJAC(SifD, Naziv, Adresa);
NABAVKA(SifN, Datum, Kolicina, Cena, SifR);

Sastaviti SQL skript koji formira tabelu NABAVKA ukoliko je poznato da se datum 
predstavlja kao celobrojna vrednost u opsegu od 1 do 365, i da cena predstavlja jediničnu 
cenu koja ne sme biti skuplja za više od 10% od cene pri prethodnoj nabavci te robe. 
Takođe je poznato da jednog datuma može biti najviše jedna nabavka jedne vrste robe.
*/

DROP DATABASE IF EXISTS SKLADISTE;

CREATE DATABASE SKLADISTE;

USE SKLADISTE;

CREATE TABLE DOBAVLJAC (
    SifD INT,
    Naziv VARCHAR(50),
    Adresa VARCHAR(100),
    PRIMARY KEY (SifD)
);

CREATE TABLE ROBA (
    SifR INT,
    Naziv VARCHAR(20),
    Opis VARCHAR(255),
    SifD INT,
    PRIMARY KEY(SifR),
    CONSTRAINT fk_sifd FOREIGN KEY (SifD) 
    REFERENCES DOBAVLJAC(SifD)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NABAVKA (
    SifN INT PRIMARY KEY,
    Datum INT NOT NULL,
    Cena INT NOT NULL,
    Kolicina INT NOT NULL,
    SifR INT NOT NULL,
    CONSTRAINT fk_sifr FOREIGN KEY (SifR)
    REFERENCES ROBA(SifR)
    ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (SifR, Datum)
);

-- Kreiraju se trigeri kojima se proverava validnost unosa

DELIMITER //

DROP TRIGGER IF EXISTS bi_nabavka;

CREATE TRIGGER bi_nabavka
BEFORE INSERT ON NABAVKA
FOR EACH ROW
    BEGIN
        IF (NEW.Kolicina <= 0) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Kolicina mora biti veca od nule!';
        ELSEIF (NEW.Cena <= 0) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Cena mora biti veca od nule!';
        ELSEIF (NEW.Datum NOT BETWEEN 1 AND 365) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Datum mora biti u opsegu od 1 do 365!';
        ELSEIF (NEW.Cena >= 1.1 * (SELECT N.Cena 
                                   FROM NABAVKA N 
                                   WHERE N.SifR = NEW.SifR AND
                                        N.Datum = (SELECT MAX(N2.Datum)
                                                   FROM NABAVKA N2 
                                                   WHERE N2.SifR = NEW.SifR AND N2.Datum < NEW.Datum))) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Cena ne sme biti veca od prethodne cene za vise od 10 posto!';
        END IF;
    END;
//

-- Ispisuju se definicije

SHOW CREATE TABLE DOBAVLJAC;

SHOW CREATE TABLE ROBA;

SHOW CREATE TABLE NABAVKA;

SHOW CREATE TRIGGER bi_nabavka;

-- Unose se podaci u tabele

INSERT INTO DOBAVLJAC VALUES 
    (100, 'Dobavljac 1', 'Adresa dobavljaca 1');

INSERT INTO ROBA VALUES 
    (1000, 'Naziv robe 1', 'Opis robe 1', 100);

INSERT INTO NABAVKA VALUES 
    (10000, 200, 300, 10, 1000);

SELECT * FROM DOBAVLJAC;

SELECT * FROM ROBA;

SELECT * FROM NABAVKA;

-- Proverava se da ne moze da se unese kolicina manja ili jednaka nuli
/*
INSERT INTO NABAVKA VALUES 
    (10001, 210, 300, 0, 1000);
*/

-- Proverava se da je cena veca od nule
/*
INSERT INTO NABAVKA VALUES 
    (10001, 210, 0, 20, 1000);
*/

-- Proverava se da je datum u opsegu od 1 do 365
/*
INSERT INTO NABAVKA VALUES 
    (10001, 500, 200, 20, 1000);
*/

-- Proverava se da ne postoje dve nabavke iste robe jednog dana
/*
INSERT INTO NABAVKA VALUES 
    (10001, 200, 200, 20, 1000);
*/

-- Proverava se da ne moze da se unese cena veca od 10 posto
-- od prethodne cene te robe
/*
INSERT INTO NABAVKA VALUES 
    (10001, 210, 400, 20, 1000);
*/

-- Ispravno se unosi nabavka robe

INSERT INTO NABAVKA VALUES 
    (10001, 210, 310, 20, 1000);

SELECT * FROM NABAVKA;


