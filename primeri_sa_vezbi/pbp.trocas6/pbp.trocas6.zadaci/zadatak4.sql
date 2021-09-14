/* 
4. Data je šema relacione baze podataka fubalskog saveza za potrebe evidencije utakmica jedne sezone
(pretpostavka je da fudbaleri ne mogu da menjaju tim u kome igraju, u toku sezone):

FUDBALER (SifF, Ime, SifT);
TIM (SifT, Naziv, Mesto);
UTAKMICA (SifU, SifTDomaci, SifTGost, Kolo, Ishod, Godina);
IGRAO (SifF, SifU, PozicijaIgraca);
GOL (SifG, SifU, SifF, RedniBrGola, Minut);
KARTON (SifK, SifU, SifF, Tip, Minut);

Sastaviti SQL skript kojim se formira tabela UTAKMICA, ukoliko je poznato da utakmicu igraju dva
različita tima čije se šifre nalaze u tabeli TIM, da ishod utakmice može biti iz skupa vrednosti
{X-nerešeno, 1-pobeda domaćih, 2-pobeda gostiju} i da postoji 42 kola u kojima se utakmice igraju. 
U toku sezone svaki par timova odigra dve utakmice, pri čemu je jedna na domaćem, a druga na 
gostujućem terenu.
*/

DROP DATABASE IF EXISTS FudbalskiSavez;

CREATE DATABASE FudbalskiSavez;

USE FudbalskiSavez;

DROP TRIGGER IF EXISTS bi_utakmica;

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

-- Triger koji proverava validnost ulaznih podataka

DELIMITER //

CREATE TRIGGER bi_utakmica
BEFORE INSERT ON UTAKMICA
FOR EACH ROW
    BEGIN
        IF (NEW.SifTGost = NEW.SifTDomaci) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Timovi moraju da budu razliciti!';
        ELSEIF (NEW.Ishod NOT IN ('X', '1', '2')) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Ishod mora da bude iz skupa X, 1 i 2!';
        ELSEIF (NEW.Kolo NOT BETWEEN 1 AND 42) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Kolo treba da bude izmedju 1 i 42!';
        END IF;
    END;
//

DELIMITER ;

-- Ispisuju se definicije

SHOW CREATE TABLE TIM;

SHOW CREATE TABLE UTAKMICA;

SHOW CREATE TRIGGER bi_utakmica;

-- Unose se podaci u tabele

INSERT INTO TIM VALUES
    (100, 'Naziv tima 1', 'Mesto tima 1'),
    (200, 'Naziv tima 2', 'Mesto tima 2');

INSERT INTO UTAKMICA VALUES 
    (1000, 100, 200, 1, 'X', 2021);

SELECT * FROM TIM;

SELECT * FROM UTAKMICA;

-- Ne moze se uneti utakmica sa dva ista tima
/*
INSERT INTO UTAKMICA VALUES 
    (1000, 100, 100, 1, 'X', 2021);
*/

-- Ishod mora biti jedna od vrednosti 'X', '1' ili '2'
/*
INSERT INTO UTAKMICA VALUES 
    (1000, 200, 100, 1, 'Y', 2021);
*/

-- Ne moze se uneti kolo van zadatog opsega
/*
INSERT INTO UTAKMICA VALUES 
    (1000, 200, 100, 50, 'X', 2021);
*/

-- Ne moze jedan tim da bude dva puta domacin istom timu
/*
INSERT INTO UTAKMICA VALUES 
    (1001, 100, 200, 2, 'X', 2021);
*/

INSERT INTO UTAKMICA VALUES 
    (1001, 200, 100, 2, '1', 2021);

SELECT * FROM UTAKMICA;

