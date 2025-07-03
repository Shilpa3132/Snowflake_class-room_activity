create or replace database purushotham_snowpipe;

use database purushotham_snowpipe;

create or replace storage integration S3_products_data_loading
type=external_stage
STORAGE_PROVIDER = S3
ENABLED = TRUE 
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::026090512481:role/purushotham_products_data_loading'
STORAGE_ALLOWED_LOCATIONS = ('s3://products-purushotham-bucket/');

desc storage integration S3_products_data_loading;

create or replace file format products_snowpipe_csv
type=csv
field_delimiter=','
skip_header=1
null_if= ('null','null')
empty_field_as_null = TRUE


create or replace stage puru_persons_stage
url='s3://products-purushotham-bucket/'
storage_integration = S3_products_data_loading 
file_format= products_snowpipe_csv

list @puru_persons_stage;

create or replace pipe persons_purushotham_pipe
auto_ingest = true
as 
copy into persons
from @puru_persons_stage
on_error = continue

select * from table(validate_pipe_load(
pipe_name => 'persons_purushotham_pipe',
start_time => dateadd(hour, -2, current_timestamp())))


CREATE or replace TABLE persons (
    Index INT PRIMARY KEY,
    UserId VARCHAR(50) NOT NULL,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Sex VARCHAR(10),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    DateOfBirth DATE,
    JobTitle VARCHAR(100)
);

select * from persons;

desc pipe persons_purushotham_pipe;

alter pipe persons_purushotham_pipe refresh;

select system$pipe_status ('persons_purushotham_pipe');

create or replace table puru_rejects as (
select REJECTED_RECORD from table(result_scan(last_query_id()))
)

select * from puru_rejects;

select 
split_part(REJECTED_RECORD,',',1) as index,
split_part(REJECTED_RECORD,',',2) as User_Id,
split_part(REJECTED_RECORD,',',3) as First_Name,
split_part(REJECTED_RECORD,',',4) as Last_Name,
split_part(REJECTED_RECORD,',',5) as Sex,
split_part(REJECTED_RECORD,',',6) as Email,
split_part(REJECTED_RECORD,',',7) as Phone,
split_part(REJECTED_RECORD,',',8) as Date_of_birth,
split_part(REJECTED_RECORD,',',9) as Job_Title
from puru_rejects; 





