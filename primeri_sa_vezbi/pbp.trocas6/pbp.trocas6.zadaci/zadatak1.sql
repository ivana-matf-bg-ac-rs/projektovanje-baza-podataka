/* Data je baza podataka Test sa sledećim relacijama:

student_mast(STUDENT_ID, NAME, ST_CLASS)
student_marks(STUDENT_ID, NAME, SUB1, SUB2, SUB3, SUB4, SUB5, TOTAL, PER_MARKS, GRADE)
student_log(USER_ID, DESCRIPTION)

Pretpostavimo da tabela student_marks sadrži podatke o studentima koji su se prijavili 
za polaganje testa. Kako test još nije završen, pretpostavimo da se u tabeli za svakog 
studenta nalaze samo vrednosti pripadajućih atributa STUDENT_ID i NAME dok su vrednosti 
svih ostalih atributa postavljene na podrazumevane vrednosti (0 ili NULL). Završen je 
test i studenti su dobili ocene za 5 različitih predmeta. Potrebno je izmeniti podatke 
o studentima u tabeli student_marks, pri čemu je za svakog studenta potrebno uneti ocene 
koje je dobio na testu za svaki od 5 predmeta. U skladu sa dobijenim ocenama potrebno je 
automatski izmeniti ukupnu ocenu za sve predmete (TOTAL), prosečnu ocenu (PER_MARKS) i 
ukupan uspeh na testu (GRADE). Vrednosti ovih atributa se izračunavaju na sledeći način:
Ukupna ocena: TOTAL = SUB1 + SUB2 + SUB3 + SUB4 + SUB5
Prosečna ocena: PER_MARKS= (TOTAL)/5
Uspeh: GRADE=- 
If PER_MARKS>=90 -> ‘EXCELLENT’- 
If PER_MARKS>=75 AND PER_MARKS<90 -> ‘VERY GOOD’- 
If PER_MARKS>=60 AND PER_MARKS<75 -> ‘GOOD’- 
If PER_MARKS>=40 AND PER_MARKS<60 -> ‘AVERAGE’- 
If PER_MARKS<40-> ‘NOT PROMOTED’
*/

DROP DATABASE IF EXISTS Test;

CREATE DATABASE Test;

USE Test;

CREATE TABLE student_mast (
    STUDENT_ID VARCHAR(10) NOT NULL PRIMARY KEY, 
    NAME VARCHAR(50) NOT NULL, 
    ST_CLASS INT NOT NULL
);

CREATE TABLE student_marks (
    STUDENT_ID VARCHAR(10) NOT NULL,
    NAME VARCHAR(50) NOT NULL, 
    SUB1 INT DEFAULT 0, 
    SUB2 INT DEFAULT 0, 
    SUB3 INT DEFAULT 0, 
    SUB4 INT DEFAULT 0, 
    SUB5 INT DEFAULT 0, 
    TOTAL INT DEFAULT 0, 
    PER_MARKS FLOAT DEFAULT 0.0, 
    GRADE VARCHAR(20),
    CONSTRAINT fk_student_id FOREIGN KEY (STUDENT_ID) 
    REFERENCES student_mast (STUDENT_ID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Kreira se triger koji prilikom izmene ocena studentu 
-- u tabeli student_marks racuna polja total, per_marks 
-- i grade 

DELIMITER $$

CREATE TRIGGER bu_student_marks
BEFORE UPDATE ON student_marks
FOR EACH ROW
    BEGIN
        SET NEW.TOTAL = NEW.SUB1 + NEW.SUB2 + NEW.SUB3 + NEW.SUB4 + NEW.SUB5;
        SET NEW.PER_MARKS = NEW.TOTAL/5;
        IF NEW.PER_MARKS >= 90 THEN
            SET NEW.GRADE = 'EXCELLENT';
        ELSEIF NEW.PER_MARKS >= 75 THEN
            SET NEW.GRADE = 'VERY GOOD';
        ELSEIF NEW.PER_MARKS >= 60 THEN
            SET NEW.GRADE = 'GOOD';
        ELSEIF NEW.PER_MARKS >= 40 THEN
            SET NEW.GRADE = 'AVERAGE';
        ELSE
            SET NEW.GRADE = 'NOT PROMOTED';
        END IF;
    END;
$$

DELIMITER ;

-- Ispisuju se definicije tabela i trigera

SHOW CREATE TABLE student_mast;

SHOW CREATE TABLE student_marks;

SHOW CREATE TRIGGER bu_student_marks;

-- Dodaje se triger koji ce izracunati ime studenta prilikom 
-- unosa u tabelu student_marks

DELIMITER $$

CREATE TRIGGER bi_student_marks
BEFORE INSERT ON student_marks
FOR EACH ROW 
    SET NEW.NAME = (SELECT name FROM student_mast WHERE STUDENT_ID = NEW.STUDENT_ID);

-- Unose se vrednosti u tabelu student_mast

INSERT INTO student_mast VALUES
    ('mi15100', 'Pera Peric', 1),
    ('mi15120', 'Laza Lazic', 2);

INSERT INTO student_marks (STUDENT_ID) VALUES
    ('mi15100');

SELECT * FROM student_mast;

SELECT * FROM student_marks;

UPDATE student_marks
SET SUB1 = '50', SUB2 = '80', SUB3 = '67', SUB4 = '90', SUB5 = '100'
WHERE STUDENT_ID = 'mi15100';

SELECT * FROM student_marks;


