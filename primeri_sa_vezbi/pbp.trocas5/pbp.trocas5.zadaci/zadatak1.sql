/* 
1. Neka je kreirana baza podataka poslovanje koja služi za praćenje poslovanja jedne 
firme koja radi sa određenom grupom proizvoda i sarađuje sa određenim brojem drugih firmi. 
Baza podataka poslovanje ima četiri tabele i to: priozvodi, firme, fakture i detalji_fakture.

proizvodi(maticni_broj*, ime, jed_mere)
firme(firma*, naziv_firme, mesto, adresa, telefon)
fakture(sifra_fakture,*, sifra_firme, datum, ulaz_izlaz)
    fakture[sifra_firme] je strani kljuc firme[firma]
detalji_fakture(id*, faktura, red_br, proizvod, kolicina, dan_cena)
    detalji_fakture[faktura] je strani kljuc fakture[sifra_fakture]
    detalji_fakture[proizvod] je strani kljuc proizvodi[maticni_broj]

Kreirati bazu poslovanje i u njoj tabele proizvodi i firme.
*/

-- Brise se baza ako postoji

DROP DATABASE IF EXISTS poslovanje;

-- Kreira se baza

CREATE DATABASE poslovanje;

USE poslovanje;

-- Kreira se tabela proizvodi

CREATE TABLE proizvodi (
    maticni_broj TINYINT(3) UNSIGNED NOT NULL,
    ime VARCHAR(50) NOT NULL,
    jed_mere VARCHAR(20) NOT NULL,
    PRIMARY KEY (maticni_broj)
);

-- Kreira se tabela firme

CREATE TABLE firme (
    firma TINYINT(3) UNSIGNED NOT NULL,
    naziv_firme VARCHAR(100) NOT NULL,
    mesto VARCHAR(50) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    PRIMARY KEY (firma)
);

-- Ispisuju se definicije tabela

SHOW CREATE TABLE proizvodi;

SHOW CREATE TABLE firme;
