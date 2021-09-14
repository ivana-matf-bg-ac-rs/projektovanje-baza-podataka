-- Indexes

USE vezbe;

DROP TABLE IF EXISTS lookup;

CREATE TABLE lookup (
    id INT,
    name VARCHAR(20),
    INDEX ind_name USING BTREE (name)
) ENGINE = MEMORY;

SHOW CREATE TABLE lookup;

-- Brisanje indeksa

ALTER TABLE lookup DROP INDEX ind_name;

SHOW CREATE TABLE lookup;

-- Dodavanje indeksa

CREATE INDEX ind_name ON lookup (name(10)) USING HASH;

SHOW CREATE TABLE lookup;
