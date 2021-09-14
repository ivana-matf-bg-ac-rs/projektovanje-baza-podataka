-- Trigeri za proveru validnost ulaza

USE vezbe;

DROP TABLE IF EXISTS test_ocena;

-- Kreira se tabela za unos ocena

CREATE TABLE test_ocena (
    ime VARCHAR(20),
    prezime VARCHAR(20),
    ocena INT
);

-- Kreira se triger kojim se ne dozvoljava unos
-- ocene koja nije u zadatom opsegu [5, 10]

DELIMITER |

CREATE TRIGGER bi_test_ocena
BEFORE INSERT ON test_ocena
FOR EACH ROW
    BEGIN
        IF NEW.ocena < 5 OR NEW.ocena > 10 THEN
            SIGNAL sqlstate '45000' SET message_text = 'Ocena mora biti u opsegu od 5 do 10!';
        END IF;
    END;
|

DELIMITER ;

-- Unosi se jedan red u tabelu

INSERT INTO test_ocena VALUES
    ('Pera', 'Peric', 10);

SELECT * FROM test_ocena;

INSERT INTO test_ocena VALUES
    ('Laza', 'Lazic', 12);

SELECT * FROM test_ocena;

