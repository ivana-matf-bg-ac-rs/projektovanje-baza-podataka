-- Pravimo dve tabele za demonstraciju
create table t1(c1 int, c2 float not null);
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
create view v2(c1, c2) as
select c1, c2*c2
from t1;

-- INSERT
insert into v2(c1, c2) values
    (7, 14);

insert into v2(c1) values
    (7);

select * from v2;

select * from t1;

-- ciscenje
drop view v2;
drop table t1;
drop table t2;