/* 
3. Kreirati SQL iskaz kojim se dodaje nova kolona sa nazivom 
primio i tipom podataka VARCHAR(50) tabeli fakture.
*/

USE poslovanje;

-- Dodaje se kolona

ALTER TABLE fakture
ADD COLUMN primio VARCHAR(50);

-- Ispisuje se definicija tabele

SHOW CREATE TABLE fakture;