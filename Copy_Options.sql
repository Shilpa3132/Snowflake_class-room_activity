-----External_stage_creation--

CREATE or replace TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING,
  effective_date STRING,
  due_date STRING,
  paid_off_time STRING,
  past_due_days STRING,
  age STRING,
  education STRING,
  Gender STRING);
  
  SELECT * from loan_payment;
  
-----creating external stage------------

  create or replace stage OUR_FIRST_DB.PUBLIC.my_stage
  url = 's3://bucketsnowflakes3/Loan_payments_data.csv';
  
list @OUR_FIRST_DB.PUBLIC.my_stage;

------load the data by using copy command-

copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT
from @OUR_FIRST_DB.PUBLIC.my_stage 
file_format=(
type=csv field_delimiter=',' skip_header=1
);

create or replace stage my_internal_stage

list @copy_db.public.my_internal_stage;

------------copy_options--------------




 create database COPY_DB;

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(4),
    SUBCATEGORY VARCHAR(30));

select * from COPY_DB.PUBLIC.ORDERS;

create or replace stage my_external_stage_copy_options
url='s3://snowflakebucket-copyoption/returnfailed/';

list @my_external_stage_copy_options;

create or replace stage my_external_stage_copy_options1
url='s3://snowflake-assignments-mc/copyoptions/example1';
list @my_external_stage_copy_options1;


------------Validation_mode =retun_error-----------

copy into COPY_DB.PUBLIC.ORDERS 
from @my_external_stage_copy_options
file_format=(type=csv field_delimiter=',' skip_header=1)
 pattern='.*Order.*'
validation_mode=return_errors;


copy into COPY_DB.PUBLIC.ORDERS 
from @my_external_stage_copy_options
file_format=(type=csv field_delimiter=',' skip_header=1)
 pattern='.*Order.*'
validation_mode=return_errors;

CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
   url = 's3://bucketsnowflakes3/'
   
list @COPY_DB.PUBLIC.aws_stage_copy;

----------on_error = continue--------
copy into COPY_DB.PUBLIC.ORDERS 
from @COPY_DB.PUBLIC.aws_stage_copy
file_format=(type=csv field_delimiter=',' skip_header=1)
--pattern='.*Order.*'
on_error=skip_file;



select * from COPY_DB.PUBLIC.ORDERS;

copy into COPY_DB.PUBLIC.ORDERS 
from @COPY_DB.PUBLIC.aws_stage_copy
file_format=(type=csv field_delimiter=',' skip_header=1)
--pattern='.*Order.*'
--on_error=skip_file;
on_error=continue;

-------------Size_limit-----------


COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @my_external_stage_copy_options
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    size_limit = 200000
    on_error=continue;

list @my_external_stage_copy_options;

-----------------force=true---------


copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT
from @OUR_FIRST_DB.PUBLIC.my_stage 
file_format=(
type=csv field_delimiter=',' skip_header=1
)
--force=true;


select * from COPY_DB.PUBLIC.ORDERS;


COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
pattern='.*Order.*'
    --truncatecolumns=true;
    

list @COPY_DB.PUBLIC.aws_stage_copy;






---------------Working with rejected records-----------------------------


CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

select count(*) from COPY_DB.PUBLIC.ORDERS;

create or replace stage my_external_stage_copy_options
url='s3://snowflakebucket-copyoption/returnfailed/';

list @my_external_stage_copy_options;

copy into COPY_DB.PUBLIC.ORDERS
from @my_external_stage_copy_options
file_format=(type=csv field_delimiter=',' skip_header=1)
validation_mode=return_errors
--on_error=continue;

copy into COPY_DB.PUBLIC.ORDERS
from @my_external_stage_copy_options
file_format=(type=csv field_delimiter=',' skip_header=1)
--validation_mode=return_errors
on_error=continue;


create or replace table rejected_records as (
select REJECTED_RECORD from table (result_scan(last_query_id())));


create table abc as (
select 
split_part(REJECTED_RECORD,',',1)as order_id,
split_part(REJECTED_RECORD,',',2)as amount,
split_part(REJECTED_RECORD,',',3)as PROFIT,
split_part(REJECTED_RECORD,',',4)as QUANTITY,
split_part(REJECTED_RECORD,',',5)as CATEGORY,
split_part(REJECTED_RECORD,',',6)as  SUBCATEGORY
from rejected_records);

insert into orders (select * from abc);

update abc 
set profit=1000
where profit='one thousand';

update abc 
set profit=220
where profit='two hundred twenty';

update abc 
set QUANTITY=7
where QUANTITY='7-';

update abc 
set QUANTITY=3
where QUANTITY='3a';

select * from rejected_records;


----------------creating Employees table------------------------------------



CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_assignment
    url='s3://snowflake-assignments-mc/copyoptions/example1';

list @COPY_DB.PUBLIC.aws_stage_assignment;

copy into copy_db.public.employees
from @COPY_DB.PUBLIC.aws_stage_assignment
file_format=(type=csv 
field_delimiter=',' 
skip_header=1)
--pattern='.*employees.*';
validation_mode=return_errors



copy into copy_db.public.employees
from @COPY_DB.PUBLIC.aws_stage_assignment
file_format=(type=csv 
field_delimiter=',' 
skip_header=1)
on_error=continue
truncatecolumns=true;

select * from COPY_DB.PUBLIC.aws_stage_assignment;

desc COPY_DB.PUBLIC.aws_stage_assignment;

Select 
$1,
$2,
$3,
$4,
$5,
$6
 from @COPY_DB.PUBLIC.aws_stage_assignment;

 create or replace table emp1 (id string, First_name string, last_name string, email string, age string, department string);

select * from emp1;

copy into emp1
from @COPY_DB.PUBLIC.aws_stage_assignment
file_format=(type=csv 
field_delimiter=',' 
skip_header=1)

get @COPY_DB.PUBLIC.aws_stage_assignment
