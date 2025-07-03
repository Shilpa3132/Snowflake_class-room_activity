create or replace table shilpa_v1 as (
select * from HR.VITECH.EMPLOYEES
);

select * from shilpa_v1;


update shilpa_v1
set first_name = 'shilpa'
where EMPLOYEE_ID = 100;


update shilpa_v1
set first_name = 'shilpa'
--where EMPLOYEE_ID = 100;

----using 0ffset--------
select * from shilpa_v1 at (offset=> -60*3);

-----using timestamp---------
select * from shilpa_v1 before(timestamp => '2025-07-01 10:30:03.491' :: timestamp);
select sysdate();

------using query_id------------
select * from shilpa_v1 before (statement => '01bd6535-3201-c005-000d-f54600069952')


------------Table Types------------

create or replace transient database vi_vision;

show databases;

create or replace transient schema Gami;



create or replace transient table Gami_data (id int, name string, salary decimal);

insert into Gami_data values(1,'gami',10000),
(2,'gami1',100000),
(3,'acdf',20000),
(4,'dsdd',30000);


select * from GAMI_DATA;

desc table GAMI_DATA;
show tables;

----We can create permanent, transient databases and schemas---
----we can not create temporary database and schemas---

create or replace temporary database vi;

CREATE or replace TEMPORARY schema your_temp_db_name;





------task----------

\\permanent table

CREATE TABLE Bpr_3112 (
    id INT,
    name STRING
);

select * from Bpr_3112;


-----transient table

CREATE TRANSIENT TABLE  Bpr_3112  (
    id INT,
    name STRING
);

------temporary table
CREATE TEMPORARY TABLE  Bpr_3112  (
    id INT,
    name STRING
);

insert into Bpr_3112 values (1001, 'purushotham'),
(1002, 'shilpa'),
(1003, 'kiran'),
(1004, 'tharun');

select * from bpr_3112;

select * from bpr_3112 where id=1003;



----- we can create permanemnt same name with temporary table-----
--we cannot create traisent table with same as permenant table---
------if we insert the data it going to insert in temporary table-------
------once you do sign out the table is going to droped--------- 


use database hr;

use schema vitech;

show tables;
alter table GAMI_DATA
set data_retention_time_in_days=10;


alter table employees 
set data_retention_time_in_days=30;


select * from employees;

select * from HR.VITECH.DEPENDENTS;


select a.*,b.* from employees a inner join dependents b
on a.employee_id= b.employee_id;


