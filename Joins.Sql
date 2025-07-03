create database shilpa;
create schema eswar;
create schema haritha;


use database shilpa;
use schema eswar;

create table mamatha (name string);
create table mamatha (name string);

drop table shilpa.eswar.mamatha;




create table lenovo (emp_id int,fname string,lname string,salary int);
create table lenovo1 (emp_id int,fname string,relationship string);
insert into lenovo values(10,'shilpa','reddy',10000),
(20,'mamatha','reddy',20000),
(30,'haritha','reddy',30000),
(40,'gami','reddy',40000),
(50,'lenovo','reddy',50000),
(60,'rajni','reddy',60000),
(70,'bpr','reddy',70000),
(80,'kiran','reddy',80000),
(90,'bhanu','reddy',90000),
(100,'mouli','reddy',100000);


select * from lenovo;

insert into lenovo1 values(5,'shilpa','parent'),
(10,'mamatha','chaild'),
(15,'haritha','parent'),
(20,'gami','chaild'),
(25,'lenovo','parent'),
(30,'rajni','chaild'),
(35,'bpr','sister'),
(40,'kiran','brother'),
(110,'bhanu','brother'),
(120,'mouli','parent');

select * from lenovo1;


select count(*) from lenovo1;

select a.*,b.* from lenovo a inner join lenovo1 b 
on a.emp_id=b.emp_id;

select a.*,b.* from lenovo a left join lenovo1 b 
on a.emp_id=b.emp_id;

select a.*,b.* from lenovo a right join lenovo1 b 
on a.emp_id=b.emp_id;

select a.*,b.* from lenovo a full join lenovo1 b 
on a.emp_id=b.emp_id;


select z.emp_id,z.fname,z.salary,
u.fname,u.relationship from lenovo z inner join lenovo1 u
on z.emp_id=u.emp_id;

select z.emp_id,z.fname,z.salary,
u.fname,u.relationship from lenovo z left join lenovo1 u
on z.emp_id=u.emp_id;

select z.emp_id,z.fname,z.salary,
u.fname,u.relationship from lenovo z right join lenovo1 u
on z.emp_id=u.emp_id;

select z.emp_id,z.fname,z.salary,
u.fname,u.relationship from lenovo z full join lenovo1 u
on z.emp_id=u.emp_id;

select z.emp_id,z.fname,z.salary,
u.fname,u.relationship from lenovo z cross join lenovo1 u;






