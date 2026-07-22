USE DATABASE SANDBOX; 

CREATE OR REPLACE TABLE TIMWILSONDV.CONTRACTDATA
(
  CONTRACT_ID INT
  ,START_DATE TIMESTAMP
  ,END_DATE TIMESTAMP
)
;

INSERT INTO TIMWILSONDV.CONTRACTDATA
(CONTRACT_ID, START_DATE, END_DATE)
VALUES
 (1, '2019-12-31','2020-02-29')
,(2, '2019-12-31','2020-02-28')
,(3, '2019-12-31','2020-12-31')
,(4, '2020-12-31','2021-12-31')
,(5, '2020-01-31','2020-12-31')
,(6, '2020-01-31','2020-12-31')
;

SELECT *
FROM TIMWILSONDV.CONTRACTDATA
;

WITH mindateselect AS (
    SELECT MIN(start_date) AS mindate
    FROM TIMWILSONDV.CONTRACTDATA
 ),
 
calendar AS (
    SELECT DATEADD(day, ROW_NUMBER() OVER (ORDER BY 1) - 1, (SELECT mindate FROM mindateselect)) AS cal_date
       ,MONTH(cal_date) as cal_month
       ,DAY(cal_date) as cal_day
       ,CASE WHEN cal_month = 2 AND cal_day = 29
            THEN 1
            ELSE 0
        END AS leap_day
    FROM TABLE(GENERATOR(rowcount => 10000))
)

SELECT *
    ,c.leap_day_sum
    ,CASE WHEN c.leap_day_sum > 0
          THEN 366
          ELSE 365
      END AS days_in_the_year
FROM TIMWILSONDV.CONTRACTDATA AS d
,LATERAL (SELECT SUM(leap_day) AS leap_day_sum 
          FROM calendar AS c
          WHERE c.cal_date >= d.start_date AND c.cal_date <= d.end_date) AS c
;




select dateadd(day,seq,dt::date) dat ,  year(dat) as "YEAR", quarter(dat) as "QUARTER OF YEAR",
       month(dat) as "MONTH", day(dat) as "DAY", dayofmonth(dat) as "DAY OF MONTH",
       dayofweek(dat) as "DAY OF WEEK",dayname(dat) as dayName,
       dayofyear(dat) as "DAY OF YEAR"
from (
select (row_number() over(order by seq)) - 1 as seq, dt
from
(
select seq4() as seq,  dateadd(month, 1, '1980-01-01'::date) dt from table(generator(rowcount => 16000))
)
)
ORDER BY DAT
;

