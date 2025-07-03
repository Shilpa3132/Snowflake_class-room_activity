CREATE or replace  STORAGE INTEGRATION S3_INT_OBJECT1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::886121092544:role/customer_data_loading'
  STORAGE_ALLOWED_LOCATIONS = ('s3://customer-puru/customers_data_1.csv');


desc STORAGE INTEGRATION S3_INT_OBJECT1;


create or replace stage customer_external_stage
url ='s3://customer-puru/customers_data_1.csv'
STORAGE_INTEGRATION = S3_INT_OBJECT1
file_format = OUR_FIRST_DB.PUBLIC.CSV_FILE_FORMAT





list @customer_external_stage;

CREATE or replace TABLE Customers (
    Index INT,
    Customer_Id VARCHAR(50),
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Company VARCHAR(150),
    City VARCHAR(100),
    Country VARCHAR(100),
    Phone_1 VARCHAR(50),
    Phone_2 VARCHAR(50),
    Email VARCHAR(150),
    Subscription_Date DATE,
    Website VARCHAR(200)
);

select * from Customers;



copy into Customers 
from @customer_external_stage;



select count(*) from Customers;

create or replace pipe customer_pipe
auto_ingest=true 
as 
copy into Customers 
from @customer_external_stage;



desc pipe customer_pipe;



alter pipe customer_pipe refresh;

alter pipe customer_pipe set pipe_execution_paused=true;




-----------------snowpipe real Time interview Questions----------------

create or replace table snow_real_int_questions as(
select * from HR.VITECH.EMPLOYEES);

select * from snow_real_int_questions

list @PRODUCTS.PRODUCTA_DATA.PRODUCT_EXTERNAL_STAGE;

create pipe snow_int_real_pipe
auto_ingest = true
as
copy into snow_real_int_questions
from @PRODUCTS.PRODUCTA_DATA.PRODUCT_EXTERNAL_STAGE
file_format=(type = csv field_delimiter=',' skip_header=1)

desc pipe snow_int_real_pipe;

alter pipe snow_int_real_pipe refresh;

select * from snow_real_int_questions

select * from table(validate_pipe_load(
pipe_name => 'snow_int_real_pipe',
start_time => dateadd(hour, -2, current_timestamp())))

create or replace  table shipa_rejects_boy_friend as (
select REJECTED_RECORD from table (result_scan(last_query_id())));

update with_shilpa_rejectted set hire_date =  null;


select * from shipa_rejects_boy_friend;
create or replace table with_shilpa_rejectted as(
select
split_part(REJECTED_RECORD,',',1)as employee_id,
split_part(REJECTED_RECORD,',',2)as First_name, 
split_part(REJECTED_RECORD,',',3)as Last_name, 
split_part(REJECTED_RECORD,',',4)as  email,
split_part(REJECTED_RECORD,',',5)as Phone_number, 
split_part(REJECTED_RECORD,',',6)as hire_date, 
split_part(REJECTED_RECORD,',',7)as job_id, 
split_part(REJECTED_RECORD,',',8)as salary, 
split_part(REJECTED_RECORD,',',9)as manager_id, 
split_part(REJECTED_RECORD,',',10)as department_id from shipa_rejects_boy_friend);



  
select * from snow_real_int_questions
 where hire_date=17-06-1987;

 SELECT * FROM shipa_rejects_boy_friend
WHERE hire_date = DATE '1987-06-17';

SELECT * from shipa_rejects_boy_friend;


