/*
1. Pogledi u već spominjanom primeru sa fudbalerima

Data je šema relacione baze podataka fubalskog
saveza za potrebe evidencije utakmica jedne
sezone (pretpostavka je da fudbaleri ne mogu da 
menjaju tim u kome igraju, u toku sezone):

FUDBALER (SifF, Ime, SifT)
TIM (SifT, Naziv, Mesto)
UTAKMICA (SifU, SifTDomaci, SifTGost, Kolo, Ishod, Godina)
IGRAO (SifF, SifU, PozicijaIgraca)
GOL (SifG, SifU, SifF, RedniBrGola, Minut)
KARTON (SifK, SifU, SifF, Tip, Minut)

Napomena: Ishod(1-pobeda domaćih, 2-pobeda gostiju, X-nerešeno)

Sastaviti SQL skript koji kao rezultat daje šifre i imena 
fudbalera kao i prosečan broj golova po utakmici koji su 
ti fudbaleri dali, ali samo za one fudbalere koji su dali 
bar jedan gol nakon što su dobili žuti karton, i to u utakmici
gde njihov tim bio gostujući.

*/

DROP DATABASE IF EXISTS FudbalskiSavez;

CREATE DATABASE FudbalskiSavez;

USE FudbalskiSavez;

-- Kreiranje tabela

CREATE TABLE TIM (
    SifT INT NOT NULL,
    Naziv VARCHAR(50) NOT NULL,
    Mesto VARCHAR(50) NOT NULL,
    PRIMARY KEY (SifT)
);

CREATE TABLE UTAKMICA (
    SifU INT NOT NULL,
    SifTDomaci INT NOT NULL,
    SifTGost INT NOT NULL,
    Kolo INT NOT NULL,
    Ishod CHAR NOT NULL,
    Godina INT,
    PRIMARY KEY (SifU),
    CONSTRAINT fk_siftdomaci FOREIGN KEY (SifTDomaci) 
    REFERENCES TIM (SifT)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_siftgost FOREIGN KEY (SifTGost) 
    REFERENCES TIM (SifT)
    ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (SifTDomaci, SifTGost)
);

CREATE TABLE FUDBALER (
    SifF INT PRIMARY KEY, 
    Ime VARCHAR(20), 
    SifT INT NOT NULL,
    CONSTRAINT fk_sift FOREIGN KEY (SifT)
    REFERENCES TIM(SifT)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IGRAO (
    SifF INT NOT NULL, 
    SifU INT NOT NULL, 
    PozicijaIgraca INT NOT NULL,
    CONSTRAINT fk_siff FOREIGN KEY (SifF)
    REFERENCES FUDBALER(SifF)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sifu FOREIGN KEY (SifU)
    REFERENCES UTAKMICA(SifU)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GOL (
    SifG INT NOT NULL PRIMARY KEY, 
    SifU INT NOT NULL, 
    SifF INT NOT NULL, 
    RedniBrGola INT NOT NULL, 
    Minut INT NOT NULL,
    CONSTRAINT fk_sifu_gol FOREIGN KEY (SifU)
    REFERENCES UTAKMICA(SifU)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_siff_gol FOREIGN KEY (SifF)
    REFERENCES FUDBALER(SifF)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE KARTON (
    SifK INT PRIMARY KEY, 
    SifU INT NOT NULL, 
    SifF INT NOT NULL, 
    Tip CHAR(1) NOT NULL, 
    Minut INT NOT NULL,
    CONSTRAINT fk_sifu_karton FOREIGN KEY (SifU)
    REFERENCES UTAKMICA(SifU)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_siff_karton FOREIGN KEY (SifF)
    REFERENCES FUDBALER(SifF)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Ispis definicija tabela 

SHOW CREATE TABLE TIM;

SHOW CREATE TABLE UTAKMICA;

SHOW CREATE TABLE FUDBALER;

SHOW CREATE TABLE IGRAO;

SHOW CREATE TABLE GOL;

SHOW CREATE TABLE KARTON;

-- Kreira se pogled u kome se za svakog fudbalera
-- koji je igrao bar jednu utakmicu izdvaja 
-- ukupan broj odigranih utakmica

CREATE OR REPLACE VIEW BrUtakmica (
    SifF,
    BrUtakmica
) AS
    SELECT SifF, COUNT (*)
    FROM IGRAO
    GROUP BY SifF;

-- Kreira se pogled koji za svakog fudbalera koji
-- je dao bar jedan gol izdvaja broj datih golova

CREATE OR REPLACE VIEW BrGolova (
    SifF,
    BrGolova
) AS
    SELECT SifF, COUNT (*)
    FROM GOL
    GROUP BY SifF;

-- Kreira se pogled koji izdvaja fudbalere koji
-- su dali gol nakon kartona na utakmici 
-- na kojoj su bili u gostujucoj ekipi

CREATE OR REPLACE VIEW DaliGolNakonKartona (
    SifF
) AS
    SELECT F.SifF
    FROM FUDBALER F, UTAKMICA U, GOL G, KARTON K
    WHERE F.SifF = G.SifF
        AND G.Minut > K.Minut
        AND K.SifF = F.SifF
        AND G.SifU = K.SifU
        AND G.SifU = U.SifU
        AND U.SifTGost = F.SifT;

-- Nije gledan tip kartona jer samo nakon zutog
-- kartona fudbaler moze nastaviti i dati gol

-- Izdvajaju se trazene informacije

SELECT F.SifF, F.Ime, BG.BrGolova/BU.BrUtakmica
FROM FUDBALER F, BrGolova BG, BrUtakmica BU
WHERE F.SifF = BG.SifF
    AND F.SifF = BU.SifF
    AND F.SifF IN (SELECT SifF FROM DaliGolNakonKartona);

-- Unos podataka

-- ZA DOMACI