show tables;
select * from LOAN_PAYMENT_V3;

CREATE or replace TABLE  LOAN_PAYMENT_V3  (
   Loan_ID  STRING,
   loan_status  STRING,
   Principal  STRING,
   terms  STRING,
   effective_date  STRING,
   due_date  STRING,
   paid_off_time  STRING,
   past_due_days  STRING,
   age  STRING,
   education  STRING,
   Gender  STRING);

   create or replace stage my_intr_payment_stage;
 list @my_intr_payment_stage;


 copy into LOAN_PAYMENT_V3 from @my_intr_payment_stage
file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
-------------------------------------------------

create database MANAGE_DB;
create schema external_stages;

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

list @MANAGE_DB.external_stages.aws_stage;



CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

    select * from MANAGE_DB.PUBLIC.ORDERS;

COPY INTO MANAGE_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';



COPY INTO OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V3
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Loan.*';
    --files = ('Loan_payments_data.csv','Loan_payments_data-2.csv');


    
// Copy command with specified file(s)

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');
    

select * from ORDERS;



// Copy command with pattern for file names

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    --pattern='.*Order.*';
   on_error = continue 
   





  -------------------------------------
