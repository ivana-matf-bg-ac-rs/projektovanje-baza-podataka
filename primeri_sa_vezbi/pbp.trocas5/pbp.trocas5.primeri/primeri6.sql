-- FOREIGN KEY Constraints

USE vezbe;

DROP TABLE IF EXISTS child;

DROP TABLE IF EXISTS parent;

CREATE TABLE parent (
    id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE child (
    id INT,
    parent_id INT,
    INDEX par_ind (parent_id),
    CONSTRAINT pk_id PRIMARY KEY (id),
    CONSTRAINT fk_parent_id FOREIGN KEY (parent_id) REFERENCES parent(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

SHOW CREATE TABLE parent;

SHOW CREATE TABLE child;

-- Brisanje stranog kljuca

ALTER TABLE child DROP FOREIGN KEY fk_parent_id;

SHOW CREATE TABLE child;

INSERT INTO child VALUES (1, 2);

SELECT * from child;

SELECT * from parent;
