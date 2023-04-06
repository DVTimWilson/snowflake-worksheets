USE DATABASE SANDBOX;
USE SCHEMA TIM_WILSON;

CREATE OR REPLACE TABLE vnt
(
 src variant
)
AS SELECT parse_json(column1) as src
FROM values
('{ 
 "topleveldate" : "2017-04-28", 
 "toplevelname" : "somename", 
 "extraFields": [ 
 { 
 "value": "somevalue1", 
 "key": "somekey1", 
 "type": "sometype1", 
 "booleanflag": false 
 }, 
 { 
 "value": "", 
 "key": "somekey2"
 }]}');

WITH a as
(
  select 
    src:topleveldate::string as topleveldate
  , src:toplevelname::string as toplevelname
  , value as val
  from vnt, lateral flatten( input => src:extraFields )
)
select topleveldate, toplevelname, key, value from a, lateral flatten( input => val );
;