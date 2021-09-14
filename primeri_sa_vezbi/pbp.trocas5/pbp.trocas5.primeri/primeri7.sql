-- CREATE TABLE ... LIKE Syntax

USE vezbe;

DROP TABLE IF EXISTS new_child;


CREATE TABLE new_child LIKE child;

SHOW CREATE TABLE new_child;

-- CREATE TABLE ... SELECT Syntax

DROP TABLE IF EXISTS foo;

CREATE TABLE foo (
    n INT NOT NULL
);

INSERT INTO foo VALUES (1);

SELECT * from foo;

DROP TABLE IF EXISTS bar;

CREATE TABLE bar (m INT) SELECT n FROM foo;

SHOW CREATE TABLE bar;

SELECT * FROM bar;

-- Postavljanje UNIQUE ogranicenja

DROP TABLE IF EXISTS bar_unique;

CREATE TABLE bar_unique (UNIQUE (n)) SELECT n FROM foo;

SHOW CREATE TABLE bar_unique;

SELECT * FROM bar_unique;