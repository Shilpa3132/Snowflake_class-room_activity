select * from employees;
select * from lenovo;

update lenovo set
salary =110000 where emp_id=10;


delete from lenovo where fname='shilpa';


update lenovo set
salary =1100000 where emp_id in(20,30)

drop table lenovo;
undrop table lenovo;

alter table lenovo add column location string;

alter table lenovo drop column location;

alter table lenovo rename column fname to first_name;

truncate table lenovo;

create or replace table lenovo as(
select * from lenovo before(statement=> '01bd1b20-3201-b504-000d-f5460001b1d6'));

delete from lenovo;

select * from lenovo before(statement=> '01bd1b28-3201-b444-000d-f54600014e2a');

create or replace table lenovo as(
select * from lenovo before(statement=> '01bd1b28-3201-b444-000d-f54600014e2a'));

select * from lenovo;
select * from lenovo where salary=50000;
select * from lenovo where salary<>50000;
select * from lenovo where salary>=50000;
select * from lenovo where salary<=50000;
select * from lenovo where salary<50000;
select * from lenovo where salary>50000;
select * from lenovo where salary between 50000 and 100000;
select * from lenovo where salary in (40000,60000,70000);
select * from lenovo where salary not in (40000,60000,70000);

select * from lenovo order by salary;
select * from lenovo order by salary  desc;
select  max(salary) from lenovo
where salary=( select max(salary) from lenovo);
select *  from lenovo
where salary=( select max(salary) from lenovo);
select  max(salary) from lenovo;

select * from lenovo where first_name like 'm%';

select * from lenovo where first_name like '%h';
select * from lenovo where first_name like '%h%';
select * from lenovo where first_name like 't__%';

select emp_id,
first_name,salary,
case 
when salary >=70000 then 'sr_software' else 'jr_software'
end as emptype
from lenovo;




with cte as (
select emp_id, first_name, lname, salary,dense_rank() over(order by salary) as rno from lenovo 
)select salary from cte where rno = 5;


with cte_emp  as (
select emp_id, first_name, lname, salary, dense_rank()over(order by salary desc) as r_id from lenovo)
select * from cte_emp where r_id=5;


        select * from(
        select emp_id, first_name,lname,salary, dense_rank()over(order by salary desc) as D_rnk from lenovo)
        where d_rnk in (3,4,5);


        select * from(
        select *, dense_rank()over(order by salary desc) as D_rnk from lenovo)
        where d_rnk in (3,4,5);

        select * from employees;


with cte_emp  as (
select *, dense_rank()over(  partition by DEPARTMENT_ID  order by salary desc) as r_id from employees) 
select * from cte_emp where r_id=1 order by department_id;

with cte_emp  as (
select *, dense_rank()over(  partition by DEPARTMENT_ID  order by salary desc) as r_id from employees) 
select * from cte_emp where r_id=2 order by department_id;

with cte_emp  as (
select *, rank()over(  partition by DEPARTMENT_ID  order by salary desc) as r_id from employees) 
select * from cte_emp 
      












































































 












