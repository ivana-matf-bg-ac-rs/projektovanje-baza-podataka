-- Trigeri

USE vezbe;

-- Kreiraju se tabele test1, test2, test3 i test4

DROP TABLE IF EXISTS test1;
DROP TABLE IF EXISTS test2;
DROP TABLE IF EXISTS test3;
DROP TABLE IF EXISTS test4;

CREATE TABLE test1 (
    a1 INT
);

CREATE TABLE test2 (
    a2 INT
);

CREATE TABLE test3 (
    a3 INT NOT NULL AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE test4 (
    a4 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    b4 INT DEFAULT 0
);

-- Kreira se triger koji prilikom unosa u tabelu test1
-- unosi tu istu vrednost iz tabele test2
-- brise tu vrednost iz table test3
-- azurira polje b4 tabele test4 u redu u kome je a4 
-- jednako vrednosti koja se unosi u tabelu test1

DELIMITER |

CREATE TRIGGER bi_test1
BEFORE INSERT ON test1
FOR EACH ROW
    BEGIN
        INSERT INTO test2 SET a2 = NEW.a1;
        DELETE FROM test3 WHERE a3 = NEW.a1;
        UPDATE test4 SET b4 = b4 + 1 WHERE a4 = NEW.a1;
    END;
|

DELIMITER ;

-- Unose se vrednosti u tabelu test3

INSERT INTO test3 (a3) VALUES
    (NULL), (NULL), (NULL), (NULL), (NULL), 
    (NULL), (NULL), (NULL), (NULL), (NULL);

INSERT INTO test4 (a4) VALUES
    (0), (0), (0), (0), (0), 
    (0), (0), (0), (0), (0);

INSERT INTO test1 VALUES
    (2), (3), (6), (3), (5), (2), (2), (6);

-- Ispisuju se sadrzaji tabela

SELECT * from test1;

SELECT * from test2;

SELECT * from test3;

SELECT * from test4;



