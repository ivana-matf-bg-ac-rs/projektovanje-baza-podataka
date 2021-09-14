-- PRIMARY KEY Constraints

USE vezbe;

DROP TABLE IF EXISTS lookup;

CREATE TABLE lookup (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);

SHOW CREATE TABLE lookup;

DROP TABLE IF EXISTS lookup2;

CREATE TABLE lookup2 (
    id INT,
    name VARCHAR(20),
    PRIMARY KEY (id)
);

SHOW CREATE TABLE lookup2;

DROP TABLE IF EXISTS lookup3;

CREATE TABLE lookup3 (
    id INT,
    name VARCHAR(20),
    PRIMARY KEY (id, name)
);

SHOW CREATE TABLE lookup3;

-- Brisanje primarnog kljuca

ALTER TABLE lookup3 DROP PRIMARY KEY;

SHOW CREATE TABLE lookup3;

-- Dodavanje primarnog kljuca

ALTER TABLE lookup3 ADD CONSTRAINT pk_id PRIMARY KEY (id);

SHOW CREATE TABLE lookup3;

