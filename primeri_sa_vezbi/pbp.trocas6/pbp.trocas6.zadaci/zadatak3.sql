/*
3. Data je relacija emp_details kao deo baze ljudskih resursa:
emp_details(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT)
    
Kreirati triger koji omogućava da se nakon svakog unošenja podataka o zaposlenima 
u tabelu emp_details izvrši provera njihove zarade i ako je zarada veća od 20000 
da se za tog zaposlenog postavi provizija od urađenog posla (COMMISSION_PCT) na 0.1 
a u suprotnom na 0.5.
*/

DROP DATABASE IF EXISTS LjudskiResursi;

CREATE DATABASE LjudskiResursi;

USE LjudskiResursi;

CREATE TABLE emp_details (
    EMPLOYEE_ID VARCHAR(10) PRIMARY KEY,
    FIRST_NAME VARCHAR(20) NOT NULL,
    LAST_NAME VARCHAR(20) NOT NULL,
    SALARY DECIMAL(10,2) NOT NULL,
    COMMISSION_PCT DECIMAL (10,2)
);

-- Kreira se triger

DELIMITER //

CREATE TRIGGER bi_emp_details
BEFORE INSERT ON emp_details
FOR EACH ROW
    BEGIN
        IF (NEW.SALARY >= 20000) THEN
            SET NEW.COMMISSION_PCT = 0.1;
        ELSE
            SET NEW.COMMISSION_PCT = 0.5;
        END IF;
    END;
//

DELIMITER ;

-- Ispisuju se definicije

SHOW CREATE TABLE emp_details;

SHOW CREATE TRIGGER bi_emp_details;

-- Unose se vrednosti u tabelu emp_details

INSERT INTO emp_details(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY) VALUES
    ('emp1', 'Pera', 'Peric', 30000),
    ('emp2', 'Laza', 'Lazic', 15000);

SELECT * FROM emp_details;
