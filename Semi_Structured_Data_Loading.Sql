
-------------creating database--------------

CREATE DATABASE JSON1;

------------create external stage--------------

create or replace stage json_external
  url='s3://bucketsnowflake-jsondemo';

 -----------to find files are loaded into stage------------- 

  list @json_external;

  --------creating table using variant data type-------------------

  create or replace table semistructured(raw_file variant);
  
  ---------Loading the data into variant data type table using copy command------------------
  
  copy into semistructured 
  from  @json_external
  file_format=(type=json);

  select * from semistructured;

  --------------------processing data rows & columns from variant(datatype) --------------
  
  select raw_file :city,
    raw_file :first_name,
    raw_file :gender,
    raw_file:id,
    raw_file:job.salary,
    raw_file:job.title,
    raw_file: last_name,
    raw_file:spoken_languages[0].language,
        raw_file:spoken_languages[0].level,
        raw_file:spoken_languages[1].language,
        raw_file:spoken_languages[2].level
    from semistructured;

-------------while processing the data rows & columns removing the " "--------------

select raw_file :city :: string as city,
    raw_file :first_name :: string as first_name,
    raw_file :gender :: string as gender,
    raw_file:id :: int as id,
    raw_file:job.salary :: int as salary,
    raw_file:job.title :: string as title,
    raw_file: last_name :: string as last_name,
    raw_file:spoken_languages[0].language :: string as languages1,
        raw_file:spoken_languages[0].level :: string as level1,
        raw_file:spoken_languages[1].language :: string as language2,
        raw_file:spoken_languages[1].level :: string as level2
    from semistructured;

-------After processing rows & columns storing the data into another table-----

    create or replace table json_into_structured as (
    select raw_file :city :: string as city,
    raw_file :first_name :: string as first_name,
    raw_file :gender :: string as gender,
    raw_file:id :: int as id,
    raw_file:job.salary :: int as salary,
    raw_file:job.title :: string as title,
    raw_file: last_name :: string as last_name,
    raw_file:spoken_languages[0].language :: string as languages1,
        raw_file:spoken_languages[0].level :: string as level1,
        raw_file:spoken_languages[1].language :: string as language2,
        raw_file:spoken_languages[1].level :: string as level2
    from semistructured);
------verfing the data where the data is loaded or not--------
    
select * from json_into_structured ;

-------Using flatten keyword------------
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

--------------parquet data loading----------

create or replace stage parquet_external
 url = 's3://snowflakeparquetdemo'
 file_format='my_parquet_format';

list @parquet_external;

 CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = 'PARQUET';

select * from @parquet_external;

select $1:__index_level_0__,
       $1:cat_id,
       $1:d, 
       $1:date,
       $1:dept_id,
       $1:id,
       $1:item_id,
	   $1:state_id,
	   $1:store_id,
	   $1:value
       from @parquet_external;

       
select $1:__index_level_0__ :: string as i_level,
       $1:cat_id :: string as c_id,
       $1:d :: string as dd,
       $1:date :: string as dat,
       $1:dept_id :: string as d_id,
       $1:id :: string as i_d,
       $1:item_id :: string as i_id,
	   $1:state_id :: string as s_id,
	   $1:store_id :: string as st_id,
	   $1:value :: string as val
       from @parquet_external;


  create or replace table parquet_table as
  (select $1:__index_level_0__ :: string as i_level,
       $1:cat_id :: string as c_id,
       $1:d :: string as dd,
       $1:date :: string as dat,
       $1:dept_id :: string as d_id,
       $1:id :: string as i_d,
       $1:item_id :: string as i_id,
	   $1:state_id :: string as s_id,
	   $1:store_id :: string as st_id,
	   $1:value :: string as val
       from @parquet_external);  

    select * from parquet_table;




    select to_json (OBJECT_CONSTRUCT(*) ) from JSON1.PUBLIC.semistructured


select to_xml (OBJECT_CONSTRUCT(*) ) from JSON1.PUBLIC.semistructured



select to_json (OBJECT_CONSTRUCT('city',city,'name',first_name) ) from OUR_FIRST_DB.PUBLIC.CITY


