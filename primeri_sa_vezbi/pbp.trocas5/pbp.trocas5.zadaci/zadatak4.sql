/* 
4. Kreirati SQL iskaz kojim se briše prethodno dodata kolona iz 
zadatka 3.
*/

USE poslovanje;

-- Brise se kolona

ALTER TABLE fakture
DROP COLUMN primio;

-- Ispisuje se definicija tabele

SHOW CREATE TABLE fakture;