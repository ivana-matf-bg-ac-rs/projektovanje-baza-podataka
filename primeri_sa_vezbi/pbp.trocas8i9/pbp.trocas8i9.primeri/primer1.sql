-- Upustvo za pokretanje db2:
-- * pokretanje db2: db2start 
-- * povezivanje na mstud bazu: db2 connect to mstud;
-- 
-- Prevodjenje skriptova:
-- * db2 < name.sql
--
-- Opcije:
-- * -t ~ postaviti da ';' razdvaja upite.
-- * -f ~ cita upit iz datoteke, cije je ime naredni arg
-- * -v ~ 'echo' upita
-- 
-- Primer:
-- * db2 -tvf name.sql > out.txt

-- Pravimo dve tabele za demonstraciju
create table t1(c1 int, c2 float);
insert into t1 values 
(5, 6.0),
(6, 7.0),
(5, 6.0);

create table t2(c1 int, c2 float);
insert into t2 values 
(5, 9.0),
(5, 4.0),
(7, 5.0);

select * from t1;
select * from t2;

-- Primer
create view v1(c1) as
select c1
from t1
where c2 > 0;

select * from v1;

-- INSERT 
insert into v1(c1) values
    (1), (2), (3), (4), (5);

-- DELETE
delete from v1
where c1 = 6;

-- UPDATE
update v1
set c1 = c1 + 5;
where c1 = 5;

select * from v1;

select * from t1;

-- ciscenje
drop view v1;
drop table t1;
drop table t2;