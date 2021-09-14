/* 
7. Kreirati SQL iskaz kojim se menja definicija kolone dan_cena 
tabele detalji_fakture tako što se naziv kolone iz dan_cena menja 
u cena i pored svega se menjaju podešavanja za tip podataka (u
prvobitnoj definiciji je bilo DECIMAL(8,2)).
*/

USE poslovanje;

-- Menja se naziv i definicija kolone

ALTER TABLE detalji_fakture
CHANGE COLUMN dan_cena cena DECIMAL(10,2);

-- Ispisuje se definicija tabele

SHOW CREATE TABLE detalji_fakture;
