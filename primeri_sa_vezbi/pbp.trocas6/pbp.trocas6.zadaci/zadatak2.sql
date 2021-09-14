/*
2. Data je baza Test iz prethodnog zadatka. Potrebno je za sve studente iz tabele
student_mast promeniti razred u sledeći. 

Kreirati triger koji proverava da uneti 
razred nije manji od starog razreda. 

Kreirati triger koji će obezbediti da se posle 
svake izmene pojedinačne n-torke u tabeli student_mast doda nova n-torka u tabelu 
student_log sa informacijom o korisniku (user_id) koji je izvršio izmenu i opisom u 
vezi izvršene izmene. 

Kreirati i triger koji nakon svakog brisanja n-torke iz tabele 
student_mast dodaje novu vrstu u tabelu student_log sa informacijom o korisniku koji 
vrši brisanje i kratkim opisom izvršenog brisanja.
*/

USE Test;

DELIMITER $$

DROP TRIGGER IF EXISTS bi_student_mast;

DROP TRIGGER IF EXISTS bu_student_mast;

CREATE TRIGGER bi_student_mast
BEFORE INSERT ON student_mast
FOR EACH ROW
    BEGIN
        IF (NEW.ST_CLASS < 1) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Razred ne moze biti manji od 1!';
        END IF;
    END;
$$

CREATE TRIGGER bu_student_mast
BEFORE UPDATE ON student_mast
FOR EACH ROW
    BEGIN
        IF (NEW.ST_CLASS < OLD.ST_CLASS) THEN
            SIGNAL sqlstate '45000' SET message_text = 'Novi razred ne moze biti manji od starog razreda!';
        END IF;
    END;
$$

DELIMITER ;

-- Unose se vrednosti u tabelu 

/*
INSERT INTO student_mast VALUES
    ('mi15130', 'Mika Mikic', 0);
*/

-- Menja se razred na prethodni

/*
UPDATE student_mast
SET ST_CLASS = 1
WHERE STUDENT_ID = 'mi15120';
*/
/*
UPDATE student_mast
SET ST_CLASS = 3
WHERE STUDENT_ID = 'mi15120';

SELECT * FROM student_mast;
*/
-- Triger koji nakon svake izmene u tabeli student_mast 
-- unosi u tabelu log izmene koje je izvrsio

DELIMITER $$

DROP TRIGGER IF EXISTS au_student_mast;

CREATE TRIGGER au_student_mast
AFTER UPDATE ON student_mast
FOR EACH ROW 
    BEGIN
        INSERT INTO student_log VALUES
            (user(), CONCAT('Izmena podataka o studentu ', OLD.NAME, ' Prethodni razred: ', OLD.ST_CLASS, ', Novi razred: ', NEW.ST_CLASS));
    END;
$$

DELIMITER ;

-- Kreira se tabela student_log

DROP TABLE IF EXISTS student_log;

CREATE TABLE student_log (
    USER_ID VARCHAR(20),
    DESCRIPTION VARCHAR(255)
);

-- Azurira se tabela studen_marks
/*
UPDATE student_mast
SET ST_CLASS = 4
WHERE STUDENT_ID = 'mi15120';

SELECT * FROM student_mast;

SELECT * FROM student_log;
*/
-- Triger koji nakon svakog brisanja studenta iz tabele
-- student_mast unosi u tabelu log izmene koje je izvrsio

DELIMITER $$

DROP TRIGGER IF EXISTS ad_student_mast;

CREATE TRIGGER ad_student_mast
AFTER DELETE ON student_mast
FOR EACH ROW 
    BEGIN
        INSERT INTO student_log VALUES
            (user(), CONCAT('Brisanje podataka o studentu ', OLD.NAME, ' Razred: ', OLD.ST_CLASS, ', Datum brisanja: ', NOW()));
    END;
$$

DELIMITER ;

-- Brisanje studenta

DELETE FROM student_mast
WHERE STUDENT_ID = 'mi15120';

-- Ispis informacija iz tabela student_mast
-- i student_log

SELECT * FROM student_mast;

SELECT * FROM student_log;

