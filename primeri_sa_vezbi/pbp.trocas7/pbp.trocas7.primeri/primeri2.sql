-- Updatable and Insertable Views

USE vezbe;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1 (
    x INT
);

CREATE TABLE t2 (
    c INT
);

INSERT INTO t1 VALUES
    (2), (3), (5), (1);

INSERT INTO t2 VALUES 
    (2), (3), (5), (1), (11), (11);

-- Kreiraju se pogledi

CREATE OR REPLACE VIEW v_sum 
AS SELECT SUM(x) AS s FROM t1;

CREATE OR REPLACE VIEW v_fields
AS SELECT * FROM t2;

CREATE OR REPLACE VIEW v_join
AS SELECT * FROM v_sum JOIN v_fields ON v_sum.s = v_fields.c;

-- Ispisuju se podaci iz pogleda

/*
SELECT * FROM v_sum;

SELECT * FROM v_fields;

SELECT * FROM v_join;
*/

-- Insertable

/*
INSERT INTO v_fields (c) VALUES 
    (20);

SELECT * FROM v_fields;
*/

-- Not insertable

/*
INSERT INTO v_join (c) VALUES
    (1);
*/

-- Updatable
/*
UPDATE v_join SET c = c + 1;

SELECT * FROM v_sum;

SELECT * FROM v_fields;

SELECT * FROM v_join;
*/

-- Not updatable

/*
UPDATE v_join SET s = s + 1;
*/

-- Deletable

/*
SELECT * FROM t2;

DELETE FROM v_fields WHERE c = 11;

SELECT * FROM t2;
*/

CREATE OR REPLACE VIEW v
AS SELECT c AS col1, 1 AS col2 FROM t2;

-- Updatable

/*
UPDATE v SET col1 = 0;

SELECT * FROM t2;
*/

-- Not updatable

/*
UPDATE v SET col2 = 0;

SELECT * FROM v;
*/