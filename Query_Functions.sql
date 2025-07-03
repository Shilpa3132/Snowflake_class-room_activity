select * from employees;
select * from departments;
select * from dependents;

----I want to fetch the employee_id which it is present departments table----
select * from employees where 
employee_id in(select * from dependents);

---employee_id in (select employee_id from dependents)--it will print only the employee_id from the deoendents table

------ I want to print the which are not present in the dependents table that i want to print---
select * from employees where
employee_id not in(select employee_id from dependents);
------ I want to print the second highest salary---------
select max(salary) from employees
where salary not in (select max(salary) from employees);

----Case statement------
---Based on salary i want to see the high,medium and low-----

select first_name, 
         salary,
         case 
            when salary > 15000 then 'Sr Employee' else 'jr Employee' 
         end as emptype
         from employees;      
----------------------------------
select first_name,salary,
case
   when salary >20000 then'High salary'
   when salary between 10000 and 20000 then 'medium'
   else 'Low'
   end as salType
   from employees
------------------------------
CTE Common Table Expression--Is a temporary table,filter

   with cte_emp as(select first_name,salary,
   case
   when salary >20000 then'High'
   when salary between 10000 and 20000 then 'medium'
   else 'Low'
   end as salType
   from employees)
   select * from cte_emp where salType ='High'
--------------------------------------------------------------------  ----Windows Functions-------
Windows functions :
1.row_number
2.dense_rank
3.rank
4.Lead 
5.Leg
----
----ROW_NUMBER(): Assigns a unique number to each row in the result set.----
select first_name,salary, 
row_number() over(order by salary desc)as rnum from employees

----DENSE_RANK(): Assigns ranks to rows without skipping rank numbers for duplicates.
       select first_name,salary,
       dense_rank() over(order by salary desc)as drank from employees
----RANK(): Assigns ranks to rows, skipping ranks for duplicates.
select first_name,salary,
rank()over(order by salary desc)as rnk from employees
---- Lead():Show each employee’s current salary and the next employee’s salary.----Last row will have NULL for next_salary.

SELECT 
  employee_id,
  first_name,
  hire_date,
  salary,
  LEAD(salary) OVER (ORDER BY hire_date) AS next_salary
FROM employees;
---Lag()Show each employee's current salary and the previous employee’s salary----First row will have NULL for previous_salary.
select
first_name,salary,
lag(salary)over(order by salary)as previous_salary
from employees

------------5th highest salary by using dense rank----
with cte_emp_salary as
(select first_name,
salary,
dense_rank()over(order by salary desc)as drank
from employees
)select * from cte_emp_salary where drank=5


---based on department id i need to find the 3rd higest salary use the dense rank and whille using the over instead of using the partion---
WITH cte_emp_salary AS (
    SELECT 
        first_name,
        salary,
        department_id,
        DENSE_RANK() OVER (
            PARTITION BY department_id 
            ORDER BY salary DESC
        ) AS rank_in_dept
    FROM employees
)
SELECT *
FROM cte_emp_salary
WHERE rank_in_dept = 3;


-----Data Functions----------
select * from employees;

----1.Curdate():Returns the current date
select current_date from employees;

---2.YEAR(date)Extracts the year from a date.
Syntax: YEAR(date)
SELECT YEAR(hire_date) FROM employees;

---3. Extracts the month number (1–12) from a date.
 Syntax: MONTH(date)
select month(hire_date) from employees;

---4.DAY(date):Returns the day of the month from a date.--
select day(hire_date)from employees;

----5.DAYNAME(date):Returns the weekday name (e.g., Monday).
select dayname(hire_date)from employees;

----6.MONTHNAME(date):Returns the name of the month (e.g., June).
select monthname(hire_date)from employees;

----7.DAYOFWEEK(date):Returns the day index of the week (1 = Sunday, 7 = Saturday).
select dayofweek(hire_date)from employees;

----8.WEEK(date):Returns the week number of the year.
select week(hire_date)from employees;

----9.QUARTER(date);Returns the quarter of the year (1 to 4).
SELECT QUARTER(hire_date) FROM employees;

---10.DATE(datetime);Extracts the date part from a DATETIME value.
select  date(hire_date)from employees;

----11.DATE_ADD(date, INTERVAL x unit); Adds a time interval to a date.
 SELECT DATEADD(MONTH, 1, hire_date) FROM employees;
 
 ----12.DATE_SUB; Subtracts a time interval from a date.
SELECT DATEADD(DAY, -10, hire_date) FROM employees;

----13.DATEDIFF(date1, date2)
Returns the number of days between two dates.
SELECT DATEDIFF(DAY, hire_date, CURRENT_DATE) FROM employees;

----14.DATEDIFF:Returns the difference between two dates in the specified unit (e.g., YEAR, MONTH, DAY).
SELECT DATEDIFF(YEAR, hire_date, CURRENT_DATE) AS years_diff
FROM employees;

----15LAST_DAY(date)
Returns the last day of the month for the given date.
select last_day(hire_date)from employees;

---16.EXTRACT(part FROM date)
Extracts a specific part (like YEAR, MONTH) from a date.
SELECT EXTRACT(YEAR FROM hire_date) FROM employees;

-----------------------
-----Number Functions-------------
---1.ABS():Returns the absolute value of a number.--
Syntax:ABS(column_name) 
SELECT ABS(salary) FROM employees;

---2.CEIL(): Returns the smallest integer greater than or equal to a number.
Syntax:CEIL(column_name)
SELECT CEIL(salary) FROM employees;

---3.FLOOR() – Returns the largest integer less than or equal to a number.
syntax:FLOOR(column_name)
select floor(salary)from  employees;

---4.ROUND()-Rounds a number to the specified number of decimal places.
SELECT 
  employee_id, 
  salary, 
  ROUND(salary, 0) AS salary_rounded
FROM employees;

---5.power():Raises a number to the power of another.
SELECT 
  employee_id, 
  salary, 
  POWER(salary, 2) AS salary_squared
FROM employees;

---6.SQRT():Returns the square root of a number.
Example: SQRT(salary) gives the square root of salary.
select sqrt(salary)from employees;

---7.SIGN() – Show if salary is positive, zero, or negative
select sign(salary)from employees

---8.Truncates a number to a specified number of decimal places.
Syntax: TRUNC(column_name, decimal_places)
SELECT TRUNC(salary, 1) AS truncated_salary FROM employees;

---9.MOD(): Returns the remainder of a division operation.
- Syntax: MOD(column_name, divisor)
SELECT MOD(salary, 2) AS remainder FROM employees;

---10.EXP() – Exponential (e^x):EXP(x) returns the value of e raised to the power of x (i.e., e^x, where e ≈ 2.71828).

SELECT 
  employee_id, 
  salary, 
  EXP(salary / 10000.0) AS exp_salary
FROM employees;


-------------using lead---------------

lead will give next record information.(forward)

create or replace table using_lead (id int,	sale_date string, amount int);

select * from using_lead;

insert into using_lead values
(1,'2024-01-01',100),
(2,'2024-01-02',120),
(3,'2024-01-03',150);

SELECT 
  id,
  sale_date,
  amount,
  LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_day_amount
FROM using_lead;




---------------using lag------------

lag will give previous record information(backword)


SELECT 
  id,
  sale_date,
  amount,
  LAG(amount, 1) OVER (ORDER BY sale_date) AS next_day_amount
FROM using_lead;