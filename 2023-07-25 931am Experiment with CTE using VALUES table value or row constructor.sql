-- Version 1: single instances of LATERAL FLATTEN each in their own CTE

-- Version 2: multiple instances of LATERAL FLATTEN in the FROM clause


-- VERSION 1
USE DATABASE TIM_WILSON;
USE WAREHOUSE SANDBOX_XS;

WITH example (_AIRBYTE_DATA) AS (
    SELECT PARSE_JSON(column1)  -- The PARSE_JSON() function returns a VARIANT
    FROM VALUES
    (
	'{
      "DV04": {
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
    }')
    ,
    ('{
      "PW09": {
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
    }'
	)
),

level1 AS (
    SELECT
        key AS employeeid
        ,value AS contents
        ,value:Message::varchar AS message
        ,value:Result::varchar AS results
        ,value:Status::varchar AS status
        ,value:isError::varchar AS iserror
    FROM example
    ,LATERAL FLATTEN( input => example._AIRBYTE_DATA )
),

level2 AS (
    SELECT
        employeeid
        ,value:ChangedDate::varchar AS changeddate
        ,value:ProjectTimesheetDate::varchar AS projecttimesheetdate
    FROM level1
    ,LATERAL FLATTEN( input => level1.contents:Result )
)

SELECT
    employeeid
    ,changeddate
    ,projecttimesheetdate
FROM level2
;


-- VERSION 2
USE DATABASE TIM_WILSON;
USE WAREHOUSE SANDBOX_XS;

WITH example (_AIRBYTE_DATA) AS (
    SELECT PARSE_JSON(column1)  -- The PARSE_JSON() function returns a VARIANT
    FROM VALUES
    (
	'{
      "DV04": {
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
    }')
    ,
    ('{
      "PW09": {
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
    }'
	)
),

details AS (
    SELECT
        f1.key::varchar AS employeeid
        ,f1.value AS contents
        ,f1.value:Message::varchar AS message
        ,f1.value:Result::varchar AS results
        ,f1.value:Status::varchar AS status
        ,f1.value:isError::varchar AS iserror
        ,f2.value:ChangedDate::varchar AS changeddate
        ,f2.value:ProjectTimesheetDate::varchar AS projecttimesheetdate
    FROM example
    ,LATERAL FLATTEN( input => example._AIRBYTE_DATA ) AS f1
    ,LATERAL FLATTEN( input => f1.value:Result ) AS f2
)

SELECT *
FROM details
;
