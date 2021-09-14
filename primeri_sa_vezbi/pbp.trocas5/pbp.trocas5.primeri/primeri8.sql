-- CREATE TABLE and Generated Columns

USE vezbe;

DROP TABLE IF EXISTS triangle;

CREATE TABLE triangle (
    sidea DOUBLE,
    sideb DOUBLE,
    sidec DOUBLE AS (SQRT(sidea * sidea + sideb * sideb))
);

SHOW CREATE TABLE triangle;

INSERT INTO triangle (sidea, sideb) VALUES (1,2), (3,4), (6,8);

SELECT * FROM triangle;

DROP TABLE IF EXISTS person;

CREATE TABLE person (
    first_name VARCHAR(20),
    last_name VARCHAR(20)
);

INSERT INTO person VALUES ('Ivana', 'Ivanic');

SELECT CONCAT(first_name, ' ', last_name) FROM person;

DROP TABLE IF EXISTS person_generated;

CREATE TABLE person_generated (
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    full_name VARCHAR (50) AS (CONCAT(first_name, ' ', last_name)) VIRTUAL
);

SHOW CREATE TABLE person_generated;

INSERT INTO person_generated (first_name, last_name) VALUES ('Ivana', 'Ivanic');

SELECT * FROM person_generated;

DROP TABLE IF EXISTS person_generated_stored;

CREATE TABLE person_generated_stored (
    full_name VARCHAR(20) AS (CONCAT(first_name, ' ', last_name)) STORED
) SELECT first_name, last_name FROM person;

SHOW CREATE TABLE person_generated_stored;

SELECT * FROM person_generated_stored;