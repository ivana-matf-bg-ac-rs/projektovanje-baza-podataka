-- CREATE TABLE Syntax

USE vezbe;

DROP TABLE IF EXISTS t;

CREATE TABLE t (
    a CHAR(20),
    b CHAR(20)
);

SHOW CREATE TABLE t;

DROP TABLE IF EXISTS t_column_constraint;

CREATE TABLE t_column_constraint (
    a CHAR(20) CHARACTER SET utf8 COLLATE utf8_bin,
    b CHAR(20)
);

SHOW CREATE TABLE t_column_constraint;

DROP TABLE IF EXISTS t_table_constraint;

CREATE TABLE t_table_constraint (
    a CHAR(20),
    b CHAR(20)
) CHARACTER SET utf8 COLLATE utf8_bin;

SHOW CREATE TABLE t_table_constraint;
