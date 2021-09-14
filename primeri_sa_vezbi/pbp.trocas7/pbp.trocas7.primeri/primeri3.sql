-- The View WITH CHECK OPTION Clause

USE vezbe;

DROP TABLE IF EXISTS t;

CREATE TABLE t (
    a INT
);

CREATE OR REPLACE VIEW v_no_check_option
AS SELECT * FROM t WHERE a < 2;

CREATE OR REPLACE VIEW v_with_check_option
AS SELECT * FROM t WHERE a < 3
WITH CHECK OPTION;

-- Unose se podaci

INSERT INTO t VALUES
    (0), (1), (2), (3), (4), (5);

-- Unos preko pogleda u kome nije aktivirana provera

/*
INSERT INTO v_no_check_option VALUES
    (6);

SELECT * FROM v_no_check_option;

SELECT * FROM t;
*/

-- Unos preko pogleda u kome je aktivirana provera

/*
INSERT INTO v_with_check_option VALUES
    (7);

SELECT * FROM v_with_check_option;

SELECT * FROM t;
*/

-- Kreiranje pogleda nad pogledom koji nije definisan 
-- sa WITH CHECK OPTION

CREATE OR REPLACE VIEW v_with_local_check_option 
AS SELECT * FROM v_no_check_option WHERE a > 0
WITH LOCAL CHECK OPTION;

CREATE OR REPLACE VIEW v_with_cascade_check_option
AS SELECT * FROM v_no_check_option WHERE a > 0
WITH CASCADED CHECK OPTION;

-- Unos podataka

/*
INSERT INTO v_with_local_check_option VALUES
    (-10);
*/

/*
INSERT INTO v_with_local_check_option VALUES
    (10);

SELECT * FROM t;
*/

/*
INSERT INTO v_with_cascade_check_option VALUES
    (-10);
*/

/*
INSERT INTO v_with_cascade_check_option VALUES
    (10);
*/

/*
INSERT INTO v_with_local_check_option VALUES
    (1);

INSERT INTO v_with_cascade_check_option VALUES
    (1);

SELECT * FROM t;
*/




