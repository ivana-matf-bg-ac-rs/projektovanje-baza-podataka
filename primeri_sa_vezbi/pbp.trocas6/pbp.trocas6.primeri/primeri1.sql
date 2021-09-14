-- Trigeri

USE vezbe;

DROP TABLE IF EXISTS account;

-- Kreira se tabela account

CREATE TABLE account (
    acct_num INT,
    amount DECIMAL(10,2)
);

-- Kreira se triger kojima se sabiraju
-- iznosi koji se unose u tabelu

CREATE TRIGGER ins_sum
BEFORE INSERT ON account
FOR EACH ROW
    SET @sum = @sum + NEW.amount;

-- Inicijalizuje se promenljiva sum

SET @sum = 0;

-- Unose se vrednosti u tabelu

INSERT INTO account VALUES
    (100, 15.00),
    (101, 25.30),
    (105, -100.50);

-- Ispisuje se suma iznosa

SELECT @sum AS 'Total amount inserted';

-- Kreira se triger koji sabira prilive i odlive

CREATE TRIGGER ins_transaction
BEFORE INSERT ON account
FOR EACH ROW PRECEDES ins_sum
    SET @deposits = @deposits + IF(NEW.amount>0, NEW.amount, 0),
        @withdrawals = @withdrawals + IF(NEW.amount<0, -NEW.amount, 0);

SET @deposits = 0;

SET @withdrawals = 0;

INSERT INTO account VALUES
    (100, 30.00),
    (101, 40.30),
    (105, -120.50);

SELECT @deposits AS 'Deposits', @withdrawals AS 'Withdrowals';

-- Kreira se triger kojim se amount postavlja da bude
-- u opsegu [0, 100]

DELIMITER //

CREATE TRIGGER ins_check
BEFORE INSERT ON account
FOR EACH ROW
    BEGIN
        IF NEW.amount < 0 THEN
            SET NEW.amount = 0;
        ELSEIF NEW.amount > 100 THEN
            SET NEW.amount = 100;
        END IF;
    END;
//

DELIMITER ;

INSERT INTO account VALUES
    (200, 30.00),
    (201, 140.30),
    (205, -120.50);

SELECT * FROM account;





