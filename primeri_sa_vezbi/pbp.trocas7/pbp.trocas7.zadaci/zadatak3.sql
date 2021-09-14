/*
3. Data je šema relacione deo baze podataka fakulteta:

STUDENT (SifS, Ime, BrIndeksa)
PROFESOR (SifP, Ime, SifO)
ODSEK (SifO, Naziv)
KURS (SifK, Naziv, BrKredita, SifO)
UČIONICA (SifU, BrMesta)
PREDUSLOV (SifK, SifKP)
POHAĐA (SifS, SifR)
RASPORED (SifR, SifP, SifK, SifU, Termin, Dan, BrPrijavljenih)

Sastaviti SQL skript koji proverava kvalitet rasporeda 
studenata i pored broja indeksa ispisuje i odgovarajuću 
poruku. Raspored studenta je loš ukoliko u svom rasporedu 
bar jednog dana ima prekid u terminima u kojima prati 
predavanje, u suprotnom raspored se smatra dobrim. Za 
sve studente sa lošim rasporedom treba ispisati broj 
indeksa i poruku LOS, a pored broja indeksa studenata sa 
dobrim rasporedom poruku DOBAR.
*/

DROP DATABASE IF EXISTS BazaFakulteta;

CREATE DATABASE BazaFakulteta;

USE BazaFakulteta;

-- Kreiranje tabela

CREATE TABLE STUDENT (
    SifS INT, 
    Ime VARCHAR(20), 
    BrIndeksa VARCHAR(10)
);

ALTER TABLE STUDENT ADD CONSTRAINT pk_sifs_student PRIMARY KEY (SifS);

CREATE TABLE ODSEK (
    SifO VARCHAR(10), 
    Naziv VARCHAR(50)
);

ALTER TABLE ODSEK ADD CONSTRAINT pk_sifo_odsek PRIMARY KEY (SifO);

CREATE TABLE PROFESOR (
    SifP INT, 
    Ime VARCHAR(20), 
    SifO VARCHAR(10)
);

ALTER TABLE PROFESOR ADD CONSTRAINT pk_sifp_profesor PRIMARY KEY (SifP);

ALTER TABLE PROFESOR ADD CONSTRAINT fk_sifo_profesor FOREIGN KEY (SifO) REFERENCES ODSEK (SifO)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE KURS (
    SifK VARCHAR(10), 
    Naziv VARCHAR(20), 
    BrKredita INT, 
    SifO VARCHAR(10)
);

ALTER TABLE KURS ADD CONSTRAINT pk_sifk_kurs PRIMARY KEY (SifK);

ALTER TABLE KURS ADD CONSTRAINT fk_sifo_kurs FOREIGN KEY (SifO) REFERENCES ODSEK (SifO)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE UČIONICA (
    SifU VARCHAR(20), 
    BrMesta INT
);

ALTER TABLE UČIONICA ADD CONSTRAINT pk_sifu_ucionica PRIMARY KEY (SifU);

CREATE TABLE PREDUSLOV (
    SifK VARCHAR(10), 
    SifKP VARCHAR(10)
);

ALTER TABLE PREDUSLOV ADD CONSTRAINT fk_sifk_preduslov FOREIGN KEY (SifK) REFERENCES KURS (SifK)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PREDUSLOV ADD CONSTRAINT fk_sifkp_preduslov FOREIGN KEY (SifKP) REFERENCES KURS (SifK)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE RASPORED (
    SifR INT, 
    SifP INT, 
    SifK VARCHAR(20), 
    SifU VARCHAR(20), 
    Termin INT, 
    Dan INT, 
    BrPrijavljenih INT
);

ALTER TABLE RASPORED ADD CONSTRAINT pk_sifr_raspored PRIMARY KEY (SifR);

ALTER TABLE RASPORED ADD CONSTRAINT fk_sifp_raspored FOREIGN KEY (SifP) REFERENCES PROFESOR (SifP)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RASPORED ADD CONSTRAINT fk_sifk_raspored FOREIGN KEY (SifK) REFERENCES KURS (SifK)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RASPORED ADD CONSTRAINT fk_sifu_raspored FOREIGN KEY (SifU) REFERENCES UČIONICA (SifU)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE POHAĐA(
    SifS INT, 
    SifR INT
);

ALTER TABLE POHAĐA ADD CONSTRAINT fk_sifs_pohadja FOREIGN KEY (SifS) REFERENCES STUDENT (SifS)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE POHAĐA ADD CONSTRAINT fk_sifr_pohadja FOREIGN KEY (SifR) REFERENCES RASPORED (SifR)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Ispis definicija tabela

SHOW CREATE TABLE STUDENT;

SHOW CREATE TABLE ODSEK;

SHOW CREATE TABLE PROFESOR;

SHOW CREATE TABLE KURS;

SHOW CREATE TABLE UČIONICA;

SHOW CREATE TABLE PREDUSLOV;

SHOW CREATE TABLE RASPORED;

SHOW CREATE TABLE POHAĐA;

-- Kreira se pogled koji izdvaja sifre studenata i dane
-- u kojima imaju los raspored

CREATE OR REPLACE VIEW LosRaspored (
    SifS,
    Dan
) AS
    SELECT P.SifS, R.Dan
    FROM POHAĐA P, RASPORED R
    WHERE P.SifR = R.SifR
    GROUP BY P.SifS, R.Dan
    HAVING COUNT (R.Termin) < (MAX(R.Termin) - MIN(R.Termin) + 1);

-- Za svakog studenta se pored broja indeksa ispisuje i 
-- da li ima los ili dobar raspored

SELECT S.BrIndeksa, 'LOS'
FROM STUDENT S
WHERE S.SifS IN (SELECT SifS FROM LosRaspored)
UNION
SELECT S.BrIndeksa, 'DOBAR'
FROM STUDENT S
WHERE S.SifS NOT IN (SELECT SifS FROM LosRaspored)
    AND S.SifS IN (SELECT SifS FROM POHAĐA)

-- Unos podataka

-- ZA DOMACI
