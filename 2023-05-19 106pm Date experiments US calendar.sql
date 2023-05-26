SET start_date = '2010-01-01';
SET end_date = '2050-12-31';

WITH cte_dates (dim_date) AS (
  SELECT TO_DATE($start_date)
  UNION ALL
  SELECT TO_DATE(DATEADD(day, 1, dim_date)) --or week, month, week, hour, minute instead of day
  FROM  cte_dates
  WHERE dim_date < TO_DATE($end_date)
),

years AS (
    SELECT DATE_PART(year, dim_date) AS cal_year
    FROM cte_dates
    GROUP BY cal_year
),

federal_holidays AS (
SELECT
        DATE_FROM_PARTS(cal_year, 1, 1) AS new_years_day
        ,DATEADD(
			day,
			MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 1, 1)) ), 7) + 14,
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 1, 1))
			) AS birthday_of_martin_luther_king_jr
        ,DATEADD(
			day,
			MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 2, 1)) ), 7) + 14,
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 2, 1))
			) AS washingtons_birthday
        ,DATEADD(
			day,
			MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 6, 1)) ), 7) - 7,
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 6, 1))
			) AS memorial_day
        ,CASE WHEN cal_year >= 2021 THEN
            DATE_FROM_PARTS(cal_year, 6, 19)
			ELSE NULL
         END AS juneteenth
        ,DATE_FROM_PARTS(cal_year, 7, 4) AS independence_day
        ,DATEADD(
			day,
			MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 9, 1)) ), 7),
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 9, 1))
			) AS labor_day
        ,DATEADD(
			day,
			MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 10, 1)) ), 7) + 7,
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 10, 1))
			) AS columbus_day
        ,DATE_FROM_PARTS(cal_year, 11, 11) AS veterans_day
        ,DATEADD(
			day,
			MOD( 7 + 4 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 11, 1)) ), 7) + 21,
			DATE_TRUNC('month', DATE_FROM_PARTS(cal_year, 11, 1))
			) AS thanksgiving_day
        ,DATE_FROM_PARTS(cal_year, 12, 25) AS christmas_day
    FROM years
),

federal_holidays_observed AS (
    SELECT
        CASE WHEN DAYNAME(new_years_day) = 'Sat' THEN DATEADD(day, -1, new_years_day) WHEN DAYNAME(new_years_day) = 'Sun' THEN DATEADD(day, 1, new_years_day) ELSE new_years_day END AS new_years_day
        ,DAYNAME(CASE WHEN DAYNAME(new_years_day) = 'Sat' THEN DATEADD(day, -1, new_years_day) WHEN DAYNAME(new_years_day) = 'Sun' THEN DATEADD(day, 1, new_years_day) ELSE new_years_day END) AS new_years_day_test
        ,birthday_of_martin_luther_king_jr
        ,washingtons_birthday
        ,memorial_day
        ,CASE WHEN DAYNAME(juneteenth) = 'Sat' THEN DATEADD(day, -1, juneteenth) WHEN DAYNAME(juneteenth) = 'Sun' THEN DATEADD(day, 1, juneteenth) ELSE juneteenth END AS juneteenth
        ,DAYNAME(CASE WHEN DAYNAME(juneteenth) = 'Sat' THEN DATEADD(day, -1, juneteenth) WHEN DAYNAME(juneteenth) = 'Sun' THEN DATEADD(day, 1, juneteenth) ELSE juneteenth END) AS juneteenth_test
        ,CASE WHEN DAYNAME(independence_day) = 'Sat' THEN DATEADD(day, -1, independence_day) WHEN DAYNAME(independence_day) = 'Sun' THEN DATEADD(day, 1, independence_day) ELSE independence_day END AS independence_day
        ,DAYNAME(CASE WHEN DAYNAME(independence_day) = 'Sat' THEN DATEADD(day, -1, independence_day) WHEN DAYNAME(independence_day) = 'Sun' THEN DATEADD(day, 1, independence_day) ELSE independence_day END) AS independence_day_test
        ,labor_day
        ,columbus_day
        ,CASE WHEN DAYNAME(veterans_day) = 'Sat' THEN DATEADD(day, -1, veterans_day) WHEN DAYNAME(veterans_day) = 'Sun' THEN DATEADD(day, 1, veterans_day) ELSE veterans_day END AS veterans_day
        ,DAYNAME(CASE WHEN DAYNAME(veterans_day) = 'Sat' THEN DATEADD(day, -1, veterans_day) WHEN DAYNAME(veterans_day) = 'Sun' THEN DATEADD(day, 1, veterans_day) ELSE veterans_day END) AS veterans_day_test
        ,thanksgiving_day
        ,CASE WHEN DAYNAME(christmas_day) = 'Sat' THEN DATEADD(day, -1, christmas_day) WHEN DAYNAME(christmas_day) = 'Sun' THEN DATEADD(day, 1, christmas_day) ELSE christmas_day END AS christmas_day
        ,DAYNAME(CASE WHEN DAYNAME(christmas_day) = 'Sat' THEN DATEADD(day, -1, christmas_day) WHEN DAYNAME(christmas_day) = 'Sun' THEN DATEADD(day, 1, christmas_day) ELSE christmas_day END) AS christmas_day_test
    FROM federal_holidays
),

federal_holidays_unpivot AS (
    SELECT holiday_date, holiday_dates AS holiday_name
    FROM
    (
    SELECT
        new_years_day
        ,birthday_of_martin_luther_king_jr
        ,washingtons_birthday
        ,memorial_day
        ,juneteenth
        ,independence_day
        ,labor_day
        ,columbus_day
        ,veterans_day
        ,thanksgiving_day
        ,christmas_day
    FROM federal_holidays_observed
    ) AS unpivot_source
    UNPIVOT
    (
        holiday_date FOR holiday_dates IN
            (
                new_years_day
                ,birthday_of_martin_luther_king_jr
                ,washingtons_birthday
                ,memorial_day
                ,juneteenth
                ,independence_day
                ,labor_day
                ,columbus_day
                ,veterans_day
                ,thanksgiving_day
                ,christmas_day
            )
    ) AS unpivot
),

calendar_dim AS (
    SELECT 
        dim_date
        ,CASE WHEN DAYNAME(dim_date) IN ('Sat', 'Sun') THEN 0
            WHEN holiday_date IS NOT NULL THEN 0
            ELSE 1
        END AS working_day
        ,holiday_name
        ,DECODE(DAYNAME(dim_date),
                     'Mon', 'Monday', 
                     'Tue', 'Tuesday', 
                     'Wed', 'Wednesday', 
                     'Thu', 'Thursday',
                     'Fri', 'Friday', 
                     'Sat', 'Saturday', 
                     'Sun', 'Sunday')  AS day_name
        ,DAYNAME(dim_date) AS day_name_abv
        ,DAYOFWEEK(dim_date) AS day_of_week
        ,MONTH(dim_date) AS month_num
        ,CONCAT(YEAR(dim_date),TO_CHAR(dim_date,'MM')) AS month_id
        ,TO_CHAR(dim_date,'MMMM') AS month_name
        ,MONTHNAME(dim_date) AS month_name_abv
        ,DATEADD(day, 1,LAST_DAY( DATEADD(MONTH,-1,dim_date),MONTH)) as first_day_month
        ,LAST_DAY(dim_date, MONTH) AS last_day_month
        ,QUARTER(dim_date) AS quarter_num
        ,CONCAT(YEAR(dim_date),'Q',QUARTER(dim_date)) AS quarter_id
        ,DATEADD(day, 1,LAST_DAY( DATEADD(quarter,-1,dim_date),QUARTER)) as first_day_quarter
        ,LAST_DAY(dim_date,QUARTER) AS last_day_quarter
        ,YEAR(dim_date) AS year
    FROM cte_dates
    LEFT OUTER JOIN federal_holidays_unpivot
    ON dim_date = holiday_date
)

SELECT *
FROM calendar_dim
ORDER BY dim_date ASC
;