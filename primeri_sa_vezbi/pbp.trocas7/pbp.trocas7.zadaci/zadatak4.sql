/*
4. Data je šema relacione baze podataka veleprodajnog lanca 
prodavnica:

PRODAVNICA(SifP, Adresa, SifM)
MESTO(SifM, Naziv)
KLIJENT(SifK, Naziv, SifM)
RACUN(SifR, SifK, SifP, SifRa, Datum)
PROIZVOD(SifPr, Naziv, Cena)
STAVKA_RACUNA(SifS, SifR, SifPr, RedniBr, Kolicina, Iznos)
RADNIK(SifRa, Ime, SifP)

Sastaviti SQL skript koji za svaki datum, za koji je izdat 
bar jedan račun, daje ukupan iznos računa izdatih do tog 
datuma (uključujući i posmatrani datum).
*/

DROP DATABASE IF EXISTS Veleprodaja;

CREATE DATABASE Veleprodaja;

USE Veleprodaja;

-- Kreiranje tabela

CREATE TABLE MESTO(
    SifM INT, 
    Naziv VARCHAR(50)
);

ALTER TABLE MESTO ADD CONSTRAINT pk_sifm_mesto PRIMARY KEY (SifM);

CREATE TABLE PRODAVNICA(
    SifP INT, 
    Adresa VARCHAR(255), 
    SifM INT
);

ALTER TABLE PRODAVNICA ADD CONSTRAINT pk_sifp_prodavnica PRIMARY KEY (SifP);

ALTER TABLE PRODAVNICA ADD CONSTRAINT fk_sifm_prodavnica FOREIGN KEY (SifM) REFERENCES MESTO (SifM)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE RADNIK(
    SifRa INT, 
    Ime VARCHAR(50), 
    SifP INT
);

ALTER TABLE RADNIK ADD CONSTRAINT pk_sifra_radnik PRIMARY KEY (SifRa);

ALTER TABLE RADNIK ADD CONSTRAINT fk_sifp_radnik FOREIGN KEY (SifP) REFERENCES PRODAVNICA (SifP)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE KLIJENT(
    SifK INT, 
    Naziv VARCHAR(50), 
    SifM INT
);

ALTER TABLE KLIJENT ADD CONSTRAINT pk_sifk_klijent PRIMARY KEY (SifK);

ALTER TABLE KLIJENT ADD CONSTRAINT fk_sifm_klijent FOREIGN KEY (SifM) REFERENCES MESTO (SifM)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE PROIZVOD(
    SifPr INT, 
    Naziv VARCHAR(50), 
    Cena DECIMAL(10,2)
);

ALTER TABLE PROIZVOD ADD CONSTRAINT pk_sifpr_proizvod PRIMARY KEY (SifPr);

CREATE TABLE RACUN(
    SifR INT, 
    SifK INT, 
    SifP INT, 
    SifRa INT, 
    Datum DATE
);

ALTER TABLE RACUN ADD CONSTRAINT pk_sifr_racun PRIMARY KEY (SifR);

ALTER TABLE RACUN ADD CONSTRAINT fk_sifk_racun FOREIGN KEY (SifK) REFERENCES KLIJENT (SifK)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RACUN ADD CONSTRAINT fk_sifp_racun FOREIGN KEY (SifP) REFERENCES PRODAVNICA (SifP)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RACUN ADD CONSTRAINT fk_sifra_racun FOREIGN KEY (SifRa) REFERENCES RADNIK (SifRa)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE STAVKA_RACUNA(
    SifS INT, 
    SifR INT, 
    SifPr INT, 
    RedniBr INT, 
    Kolicina DECIMAL(8,2), 
    Iznos DECIMAL(8,2)
);

ALTER TABLE STAVKA_RACUNA ADD CONSTRAINT pk_sifs_stavka_racuna PRIMARY KEY (SifS);

ALTER TABLE STAVKA_RACUNA ADD CONSTRAINT fk_sifr_stavka_racuna FOREIGN KEY (SifR) REFERENCES RACUN (SifR)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE STAVKA_RACUNA ADD CONSTRAINT fk_sifpr_stavka_racuna FOREIGN KEY (SifPr) REFERENCES PROIZVOD (SifPr)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Izlistavaju se definicije tabela

SHOW CREATE TABLE MESTO;

SHOW CREATE TABLE PRODAVNICA;

SHOW CREATE TABLE RADNIK;

SHOW CREATE TABLE KLIJENT;

SHOW CREATE TABLE PROIZVOD;

SHOW CREATE TABLE RACUN;

SHOW CREATE TABLE STAVKA_RACUNA;

-- Kreira se pogled koji za svaki datum izdvaja
-- ukupan iznos racuna koji su napravljeni tog
-- datuma

CREATE OR REPLACE VIEW IznosPoDatumu (
    Datum,
    Iznos
) AS 
    SELECT R.Datum, SUM(S.Iznos)
    FROM RACUN R, STAVKA_RACUNA S
    WHERE R.SifR = S.SifR
    GROUP BY R.Datum;

-- Za svaki datum izdvaja se ukupan iznos racuna
-- koji su napravljeni do tog datuma, ukljucujuci
-- i njega

SELECT A.Datum, SUM(B.Iznos)
FROM IznosPoDatumu A, IznosPoDatumu B
WHERE A.Datum >= B.Datum
GROUP BY A.Datum;

-- Unos podataka

-- ZA DOMACI


