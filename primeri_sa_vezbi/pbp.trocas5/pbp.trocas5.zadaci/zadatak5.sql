/* 
5. Kreirati SQL iskaz kojim se menja definicija kolone kolicina 
tabele detalji_fakture u smislu promene podešavanja za tip podataka.
*/

USE poslovanje;

-- Menja se definicija kolone

ALTER TABLE detalji_fakture
MODIFY COLUMN kolicina DECIMAL (6,2);

-- Ispisuje se definicija tabele

SHOW CREATE TABLE detalji_fakture;

