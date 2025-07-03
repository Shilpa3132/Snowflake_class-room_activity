create or replace database clone_database
clone COPY_DB;

CREATE TABLE employees_rajani (
    emp_id INT PRIMARY KEY,
    name STRING NOT NULL,
    manager_id INT
);

select * from employees_rajani



INSERT INTO employees_rajani (emp_id, name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'Dave', 2),
(5, 'Eve', 2);

SELECT
    e.emp_id AS employee_id,
    e.name AS employee_name,
    m.emp_id AS manager_id,
    m.name AS manager_name
FROM
    employees_rajani e
left JOIN employees_rajani m ON e.manager_id = m.emp_id order by employee_id ;
