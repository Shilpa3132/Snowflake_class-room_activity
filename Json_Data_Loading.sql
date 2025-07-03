create or replace database json;

create or replace schema data;


// First step: Load Raw JSON

CREATE OR REPLACE stage json.data.JSON_STAGE
     url='s3://bucketsnowflake-jsondemo'
     file_format = JSON_FORMAT;

    
CREATE OR REPLACE file format json.data.JSON_FORMAT
    TYPE = JSON;

    list @json.data.JSON_STAGE
    select * from @json.data.JSON_STAGE;
    
CREATE OR REPLACE table json.data.JSON_RAW (
    raw_file variant);
    
COPY INTO json.data.JSON_RAW
    FROM @json.data.JSON_STAGE
    file_format= JSON_FORMAT
    --files = ('HR_data.json');
    
   
SELECT * FROM json.data.JSON_RAW;

----------------------------------------------------

        Transforming Raw_Data to CSV

--------------------------------------------------------
CREATE OR REPLACE TABLE json.data.Person_Details AS (
select 
    $1 : city :: string as CITY,                     -- dot notation
    $1 : first_name :: string as f_name,
    $1 : gender :: string as Gender,
    $1 : id :: int as ID,
    $1:job.salary:: string as Salary,
   $1:job.title:: string as Title,
    $1 : last_name :: string as l_name,
    $1 : prev_company :: string as Previous_Company,
    $1:spoken_languages[0].language :: string as first_lang ,
         $1:spoken_languages[0].level:: string as first_lvel,
          $1:spoken_languages[1].language :: string as second_lang ,
         $1:spoken_languages[1].level:: string as second_lvel
                FROM json.data.JSON_RAW
    );

    select * from json.data.Person_Details;
------- another way (transformed "Null" and "[]")-------------

CREATE or replace TABLE json.data.Person_Details1 AS (
SELECT 
    $1:city::string AS CITY,
    $1:first_name::string AS f_name,
    $1:gender::string AS Gender,
    $1:id::int AS ID,
    '$' || TO_VARCHAR($1:job.salary::int) AS Salary,
    $1:job.title::string AS Title,
    CASE 
        WHEN ARRAY_SIZE($1:prev_company) = 0 THEN 'Not Working'
        ELSE ARRAY_TO_STRING($1:prev_company, ', ')
    END AS Previous_Company,
    $1:last_name::string AS l_name,
    $1:spoken_languages[0].language::string AS first_lang,
    $1:spoken_languages[0].level::string AS first_level,
    CASE 
    WHEN $1:spoken_languages[1].language IS NOT NULL THEN $1:spoken_languages[1].language::string 
    ELSE 'N/A' 
END AS second_lang,
$1:spoken_languages[0].level::string AS second_lvel
FROM json.data.JSON_RAW
);

select * from json.data.Person_Details1;

--------------------------------------------------------




SELECT RAW_FILE : city :: STRING AS CITY ,
       raw_file : first_name :: sTRING AS FIRST_NAME,
       RAW_FILE : gender :: STRING AS GENDER
     FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT * FROM OUR_FIRST_DB.PUBLIC.CITY 


CREATE TABLE OUR_FIRST_DB.PUBLIC.CITY AS (
  SELECT RAW_FILE : city :: STRING AS CITY ,
       raw_file : first_name :: sTRING AS FIRST_NAME,
       RAW_FILE : gender :: STRING AS GENDER
     FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
)


SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT $1: first_name :: string as name ,
       $1: city :: string as city ,
       $1:spoken_languages[0].language :: string as first_lang ,
         $1:spoken_languages[0].level:: string as first_lvel,
          $1:spoken_languages[1].language :: string as second_lang ,
         $1:spoken_languages[1].level:: string as second_lvel
   FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


create table spoken_languages as (
SELECT $1: first_name :: string as name ,
       $1: city :: string as city ,
       $1:spoken_languages[0].language :: string as first_lang ,
         $1:spoken_languages[0].level:: string as first_lvel,
          $1:spoken_languages[1].language :: string as second_lang ,
         $1:spoken_languages[1].level:: string as second_lvel
   FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
)


select * from spoken_languages


select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;


---------------------------------------------------


CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT
    TYPE = 'parquet';

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'   
    FILE_FORMAT = MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT;
    
    
    // Preview the data
    
LIST  @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;   
    
SELECT top 5 * FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
    


// File format in Queries

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'  


    -----------------

SELECT * FROM OUR_FIRST_DB.PUBLIC.CITY


select to_json (OBJECT_CONSTRUCT(*) ) from OUR_FIRST_DB.PUBLIC.CITY


select to_xml (OBJECT_CONSTRUCT(*) ) from OUR_FIRST_DB.PUBLIC.CITY



select to_json (OBJECT_CONSTRUCT('city',city,'name',first_name) ) from OUR_FIRST_DB.PUBLIC.CITY
