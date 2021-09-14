/*
2. Sastaviti SQL skript koji kao rezultat daje šifre i imena 
fudbalera, ali samo za one fudbalere koji su dali bar dva 
gola i to na nekoj od utakmica na kojoj je njihov tim pobedio, 
i pritom su tačno dva gola tog fudbalera bili ujedno i 
poslednji golovi na utakmici.
*/

USE FudbalskiSavez;

-- Kreira se pogled kojim se izdvajaju sifre fudbalera
-- i utakmice na kojima su ucestvovali takve da su ispunjeni
-- trazeni uslovi

CREATE OR REPLACE VIEW Uslov (
    SifF,
    SifU
) AS 
    SELECT F.SifF, U.SifU
    FROM FUDBALER F, UTAKMICA U, GOL GOL
    WHERE F.SifF = G.SifF
        AND G.SifU = U.SifU
        AND ( (F.SifT = U.SifTDomaci AND Ishod = '1')
                OR
              (F.SifT = U.SifTGost AND Ishod = '2') )
        AND NOT EXISTS (SELECT SifF
                        FROM GOL L
                        WHERE L.SifF <> F.SifF
                            AND L.SifU = U.SifU
                            AND L.Minut > G.Minut)
    GROUP BY F.SifF, U.SifU
    HEAVING COUNT(*) = 2;

-- Izdvajaju se imena i sifre za sifre fudbalera koji su 
-- obuhvaceni pogledom

SELECT DISTINCT F.SifF, F.Ime
FROM FUDBALER F, Uslov U
WHERE F.SifF = U.SifF;

-- Unos podataka

-- ZA DOMACI
