USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE DEVELOPER_WH;
USE DATABASE SANDBOX;
USE SCHEMA SHARED;


CREATE OR REPLACE TABLE DBUSERS (NAME VARCHAR,CREATED_ON TIMESTAMP_LTZ,LOGIN_NAME VARCHAR,DISPLAY_NAME VARCHAR,FIRST_NAME VARCHAR,LAST_NAME VARCHAR,EMAIL VARCHAR,MINS_TO_UNLOCK VARCHAR,DAYS_TO_EXPIRY VARCHAR,TCOMMENT VARCHAR,DISABLED VARCHAR,MUST_CHANGE_PASSWORD VARCHAR,SNOWFLAKE_LOCK VARCHAR,DEFAULT_WAREHOUSE VARCHAR,DEFAULT_NAMESPACE VARCHAR,DEFAULT_ROLE VARCHAR,DEFAULT_SECONDARY_ROLES VARCHAR,EXT_AUTHN_DUO VARCHAR,EXT_AUTHN_UID VARCHAR,MINS_TO_BYPASS_MFA VARCHAR,OWNER VARCHAR,LAST_SUCCESS_LOGIN TIMESTAMP_LTZ,EXPIRES_AT_TIME TIMESTAMP_LTZ,LOCKED_UNTIL_TIME TIMESTAMP_LTZ,HAS_PASSWORD VARCHAR,HAS_RSA_PUBLIC_KEY VARCHAR,
                                 REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()) COMMENT = 'stores snapshot of current snowflake users' ;
CREATE OR REPLACE TABLE DBROLES (CREATED_ON TIMESTAMP_LTZ,NAME VARCHAR,IS_DEFAULT VARCHAR,IS_CURRENT VARCHAR,IS_INHERITED VARCHAR,ASSIGNED_TO_USERS NUMBER,GRANTED_TO_ROLES NUMBER,GRANTED_ROLES NUMBER,OWNER VARCHAR,RCOMMENT VARCHAR,
                                 REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())COMMENT = 'stores snapshot of current snowflake roles' ;
CREATE OR REPLACE TABLE DBGRANTS (CREATED_ON TIMESTAMP_LTZ,ROLE VARCHAR,PRIVILEGE VARCHAR,GRANTED_ON VARCHAR,NAME VARCHAR,GRANTED_TO VARCHAR,GRANTEE_NAME VARCHAR,GRANT_OPTION VARCHAR,GRANTED_BY VARCHAR,
                                                                   REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())COMMENT = 'stores snapshot of current grants' ;


-- stored procedures --
CREATE OR REPLACE PROCEDURE SNAPSHOT_USERS() RETURNS VARCHAR LANGUAGE JAVASCRIPT 
COMMENT = 'Captures the snapshot of users and inserts the records into dbusers ' 
EXECUTE AS CALLER AS $$var result = "SUCCESS";
try {snowflake.execute( {sqlText: "TRUNCATE TABLE DBUSERS;"} );
snowflake.execute( {sqlText: "show users;"} );
var dbusers_tbl_sql = 'insert into dbusers select * ,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));';
snowflake.execute( {sqlText: dbusers_tbl_sql} );} 
catch (err) {result = "FAILED: Code: " + err.code + "\n State: " + err.state;
result += "\n Message: " + err.message;
result += "\nStack Trace:\n" + err.stackTraceTxt;}
return result;$$;

CREATE OR REPLACE PROCEDURE SNAPSHOT_ROLES() RETURNS VARCHAR LANGUAGE JAVASCRIPT 
COMMENT = 'Captures the snapshot of roles and inserts the records into dbroles ' 
EXECUTE AS CALLER AS $$var result = "SUCCESS"; 
try {snowflake.execute( {sqlText: "truncate table DBROLES;"} );
snowflake.execute( {sqlText: "show roles;"} );
var dbroles_tbl_sql = 'insert into dbroles select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));';
snowflake.execute( {sqlText: dbroles_tbl_sql} );} 
catch (err) {result = "FAILED: Code: " + err.code + "\n State: " + err.state;
result += "\n Message: " + err.message;
result += "\nStack Trace:\n" + err.stackTraceTxt;}
return result;$$;

CREATE OR REPLACE PROCEDURE SNAPSHOT_GRANTS() RETURNS VARCHAR LANGUAGE JAVASCRIPT 
COMMENT = 'Captures the snapshot of grants and inserts the records into dbgrants'
EXECUTE AS CALLER AS $$function role_grants() {var obj_rs = snowflake.execute({sqlText: 'SELECT NAME FROM DBROLES;'});
while(obj_rs.next()) {snowflake.execute({sqlText: 'show grants to role "' + obj_rs.getColumnValue(1) + '" ;' });
snowflake.execute( {sqlText:`insert into dbgrants (created_on,privilege,granted_on,name,granted_to,grantee_name,grant_option,granted_by,refresh_date) select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
snowflake.execute({sqlText: 'show grants on role "' + obj_rs.getColumnValue(1) + '" ;' });
snowflake.execute( {sqlText:`insert into dbgrants (created_on,privilege,granted_on,name,granted_to,grantee_name,grant_option,granted_by,refresh_date) select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});}}
// — — — — — — — — — — — — — — — — — — — — — — — —
function user_grants(){var obj_rs = snowflake.execute({sqlText: 'SELECT NAME FROM DBUSERS;'});
while(obj_rs.next()) {snowflake.execute({sqlText: 'show grants to user "' + obj_rs.getColumnValue(1) + '" ;' });
snowflake.execute( {sqlText:`insert into dbgrants (created_on,role,granted_to,grantee_name,granted_by,refresh_date) select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
snowflake.execute({sqlText: 'show grants on user "' + obj_rs.getColumnValue(1) + '" ;' });
snowflake.execute( {sqlText:`insert into dbgrants (created_on,privilege,granted_on,name,granted_to,grantee_name,grant_option,granted_by,refresh_date) select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});}}
// — — — — — — — — — — — — — — — — — — — — — — — —
var result = "SUCCESS";
try {snowflake.execute( {sqlText: "truncate table DBGRANTS;"} );
role_grants();user_grants();} 
catch (err) {result = "FAILED: Code: " + err.code + "\n State: " + err.state;
result += "\n Message: " + err.message;
result += "\nStack Trace:\n" + err.stackTraceTxt;}
return result;$$;

USE ROLE ACCOUNTADMIN;
USE DATABASE SANDBOX;
USE SCHEMA SHARED;
CALL SNAPSHOT_USERS();
CALL SNAPSHOT_ROLES();
CALL SNAPSHOT_GRANTS();
