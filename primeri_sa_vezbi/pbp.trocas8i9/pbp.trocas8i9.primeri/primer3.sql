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
create view v3(c1, c2, c3) as
select t1.c1, t1.c2, t2.c2
from t1 join t2 on t1.c1 = t2.c1;

select * from v3;


-- ciscenje
drop view v3;
drop table t1;
drop table t2;