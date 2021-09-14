/* 
6. Kreirati SQL iskaz kojim se menja definicija kolone kolicina 
tabele detalji_fakture u smislu vraćanja na prvobitnu definiciju.
*/

USE poslovanje;

-- Menja se definicija kolone

ALTER TABLE detalji_fakture
MODIFY COLUMN kolicina DECIMAL (8,2) NOT NULL;

-- Ispisuje se definicija tabele

SHOW CREATE TABLE detalji_fakture;