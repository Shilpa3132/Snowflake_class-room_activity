create database OUR_FIRST_DB;

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
  select * from LOAN_PAYMENT;
  delete from LOAN_PAYMENT;
  ----------Using Copy command--------------
  COPY INTO LOAN_PAYMENT
    FROM s3://bucketsnowflakes3/Loan_payments_data.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
---------------------------------------------

SELECT 
    LOAN_ID,
    LOAN_STATUS,
    PRINCIPAL,
    TERMS,
    EFFECTIVE_DATE,
    DUE_DATE,
    PAID_OFF_TIME,
    PAST_DUE_DAYS,
    EDUCATION,
    GENDER,
    AGE,
    CASE 
        WHEN AGE > 21 THEN 'Major' 
        ELSE 'Minor' 
    END AS Status,
    CASE 
        WHEN AGE >= 21 THEN 'male' 
        ELSE 'female' 
    END AS gender_by_age
FROM 
    LOAN_PAYMENT  
ORDER BY 
    AGE ASC;





---------------------------------------

    CREATE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V1 (
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

  select * from LOAN_PAYMENT_V1;
  ---------create stage----------
create or replace stage OUR_FIRST_DB.PUBLIC.ext_loan_stage 
    url= 's3://bucketsnowflakes3/Loan_payments_data.csv'

list @OUR_FIRST_DB.PUBLIC.ext_loan_stage ;


COPY INTO LOAN_PAYMENT_V1
    FROM @OUR_FIRST_DB.PUBLIC.ext_loan_stage
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);

  
 select * from LOAN_PAYMENT_V1;
-------------------------------------------

CREATE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V2 (
  Loan_ID STRING,
  loan_status STRING,
  age int);

  select * from LOAN_PAYMENT_V2 ;
  COPY INTO OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V2 (Loan_ID,loan_status,age)
    FROM (select 
            s.$1,
            s.$2,
            s.$9
           -- case when s.$9 > 21 then 'Major' else 'Minor' end  as "Status"
          from @OUR_FIRST_DB.PUBLIC.ext_loan_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1) ;

select * from LOAN_PAYMENT_V2 ;
-----------------------------------------------------
----create orders table---------------
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

    select * from ORDERS;

----------using copy command--------------
     COPY INTO ORDERS
    --FROM s3://bucketsnowflakes3
    from s3://bucketsnowflakes3/OrderDetails.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);

                  
create or replace stage OUR_FIRST_DB.PUBLIC.ORDERS
    url= s3://bucketsnowflakes3

list @OUR_FIRST_DB.PUBLIC.ORDERS ;
select count(*) from ORDERS ;


--create or replace file_format file_csv
CREATE OR REPLACE FILE FORMAT file_csv
TYPE = 'CSV'
FIELD_DELIMITER = ',' 
SKIP_HEADER = 1
EMPTY_FIELD_AS_NULL = TRUE
TRIM_SPACE = TRUE;



create or replace stage external_stage
url = 's3://bucketsnowflakes3/'
 file_format = file_csv;

 list @external_stage;


 
  



                   