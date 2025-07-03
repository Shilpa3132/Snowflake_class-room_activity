

CREATE STORAGE INTEGRATION S3_INT_OBJECT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::886121092544:role/shilpa-3132'
  STORAGE_ALLOWED_LOCATIONS = ('s3://shilpa-snow-s3/csv/');


  desc  INTEGRATION S3_INT_OBJECT


  create or replace file format csv_file_format
  type=csv
  field_delimiter=',' 
  skip_header=1
  null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'   
    

  
 create or replace stage netfix_external_stage
  url='s3://shilpa-snow-s3/csv/'
   STORAGE_INTEGRATION = S3_INT_OBJECT
  file_format = csv_file_format

  list @netfix_external_stage;

  select * from @netfix_external_stage;



create or replace table netfix(show_id string,	type string,	title string,	director string,	cast string,	country	string, date_added string,	release_year string,	rating string,	duration string,	listed_in String,description string
);

select * from netfix;

copy into netfix
from @netfix_external_stage;

---------------musical_intermentation------------


CREATE STORAGE INTEGRATION S3_musical
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::886121092544:role/musical'
  STORAGE_ALLOWED_LOCATIONS = ('s3://musical-int/Musical_Instruments_5.json');

desc STORAGE INTEGRATION S3_musical;



create or replace file format json_file_format
  type=json
  null_if = ('NULL','null')

CREATE OR REPLACE STAGE musical_external_stage 
  URL = 's3://musical-int/Musical_Instruments_5.json'
  STORAGE_INTEGRATION = S3_musical
  FILE_FORMAT = json_file_format;

  list @musical_external_stage ;


  select count(*) from @musical_external_stage;



CREATE OR REPLACE table muscial_Instruments (
    raw_file variant);
    
COPY INTO muscial_Instruments
    FROM @musical_external_stage
    file_format= json_file_format
    

select * from muscial_Instruments;

select  raw_file:  asin,
   raw_file: helpful,
   raw_file: overall ,
   raw_file:reviewText,
   raw_file: reviewTime ,
   raw_file: reviewerID,
   raw_file: reviewerName, 
   raw_file:summary, 
   raw_file:unixReviewTime
   from muscial_Instruments;
   
select  raw_file:  asin ::String as a_id,
   raw_file: helpful :: String as help_id,
   raw_file: overall :: String as o_all,
   raw_file: reviewText :: String as rev_text,
   raw_file: reviewTime :: String as rev_time,
   raw_file: reviewerID:: String as ev_id,
   raw_file: reviewerName :: String as rev_name,
   raw_file: summary :: String as summary,
   raw_file: unixReviewTime :: String as uni_rev_time
   from muscial_Instruments;

  create or replace table muscial_instruments_structured as (
  select  raw_file:  asin ::String as a_id,
   raw_file: helpful :: String as help_id,
   raw_file: overall :: String as o_all,
   raw_file: reviewText :: String as rev_text,
   raw_file: reviewTime :: String as rev_time,
   raw_file: reviewerID:: String as ev_id,
   raw_file: reviewerName :: String as rev_name,
   raw_file: summary :: String as summary,
   raw_file: unixReviewTime :: String as uni_rev_time,
   from muscial_Instruments
   );


   select count(*) from muscial_instruments_structured;

   Select * from muscial_instruments_structured;


   