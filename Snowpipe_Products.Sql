create database Products;
create schema Producta_data;

create or replace storage integration products_integration
TYPE = EXTERNAL_STAGE
storage_provider= S3
Enabled=true
storage_aws_role_arn='arn:aws:iam::886121092544:role/product-roles'
storage_allowed_locations=('s3://products-mybucket/');



arn:aws:s3:::products-mybucket

desc storage integration products_integration; 


---Create file format object
CREATE OR REPLACE file format product_my_file_format
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'  


create  or replace stage product_external_stage
url = 's3://products-mybucket/'
storage_integration = products_integration
file_format = product_my_file_format


list @product_external_stage;

CREATE or replace TABLE products (
    Index INTEGER,
    Name STRING,
    Description STRING,
    Brand STRING,
    Category STRING,
    Price NUMBER(10,2),
    Currency STRING(3),
    Stock INTEGER,
    EAN STRING,
    Color STRING,
    Size STRING,
    Availability STRING,
    Internal_ID STRING
);


select * from products;

explain create or replace pipe product_pipe
auto_ingest = true
as
copy into products 
from @product_external_stage
on_error=continue;



desc pipe product_pipe;


explain alter pipe product_pipe refresh;

alter pipe product_pipe set pipe_execution_paused = false;

select system$pipe_status('product_pipe')

SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') 

