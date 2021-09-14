-- Storage Engines

USE vezbe;

SHOW ENGINES;

CREATE TABLE t_innodb (
    i INT
) ENGINE = INNODB;

CREATE TABLE t_csv (
    i INT NOT NULL
) ENGINE = CSV;

CREATE TABLE t_memory (
    i INT
) ENGINE = MEMORY;

SHOW CREATE TABLE t_innodb;

SHOW CREATE TABLE t_csv;

SHOW CREATE TABLE t_memory;