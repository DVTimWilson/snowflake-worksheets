USE DATABASE SANDBOX;
USE SCHEMA TIM_WILSON;

CREATE OR REPLACE TABLE example
(
 _AIRBYTE_DATA variant
)
AS SELECT parse_json(column1) as _AIRBYTE_DATA
FROM values
('{
  "EmployeeID": "DV04", "Contents": {
    "Message": "The requested processed successfully.",
    "Result": [
      {
        "ChangedDate": "2023-01-30",
        "EndTime": "16:00",
        "Notes": "",
        "ProjectTimesheetDate": "2023-01-27",
        "Quantity": "0.00",
        "StartTime": "09:00",
        "TimesheetDetail": "",
        "TimesheetProject": "TMHCC Titan",
        "TimesheetTask": "Billable",
        "TotalHours": "7:00",
        "TransactionId": "9263300"
      },
      {
        "ChangedDate": "2023-01-30",
        "EndTime": "16:00",
        "Notes": "",
        "ProjectTimesheetDate": "2023-01-30",
        "Quantity": "0.00",
        "StartTime": "09:00",
        "TimesheetDetail": "",
        "TimesheetProject": "TMHCC Titan",
        "TimesheetTask": "Billable",
        "TotalHours": "7:00",
        "TransactionId": "9263311"
      },
      {
        "ChangedDate": "2023-01-30",
        "EndTime": "16:00",
        "Notes": "",
        "ProjectTimesheetDate": "2023-01-31",
        "Quantity": "0.00",
        "StartTime": "09:00",
        "TimesheetDetail": "",
        "TimesheetProject": "TMHCC Titan",
        "TimesheetTask": "Billable",
        "TotalHours": "7:00",
        "TransactionId": "9263312"
      }
    ],
    "Status": "0",
    "isError": false
  }
}');

WITH level1 AS (
    SELECT
        _AIRBYTE_DATA:EmployeeID::varchar AS employeeid
        ,_AIRBYTE_DATA:Contents AS contents
    FROM example
    ,LATERAL FLATTEN( input => _AIRBYTE_DATA )
),

level2 AS (
    SELECT
        employeeid
        ,contents:Message AS message
        ,contents:Result AS result
    FROM level1
    ,LATERAL FLATTEN( input => contents )
)

SELECT
    employeeid
    ,message
    ,result[0].ChangedDate::varchar AS changeddate
    ,result[0].EndTime::varchar AS endtime
--    ,result
FROM level2
,LATERAL FLATTEN( input => result )
;