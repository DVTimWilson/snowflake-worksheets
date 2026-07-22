-- Snowflake
WITH date_data(d) AS (
    SELECT '2016-12-31' :: TIMESTAMP
    UNION ALL
    SELECT '2017-01-01' :: TIMESTAMP
    UNION ALL
    SELECT '2017-01-02' :: TIMESTAMP
    UNION ALL
    SELECT '2017-01-03' :: TIMESTAMP
    UNION ALL
    SELECT '2017-01-04' :: TIMESTAMP
    UNION ALL
    SELECT '2017-01-05' :: TIMESTAMP
    UNION ALL
    SELECT '2017-12-30' :: TIMESTAMP
    UNION ALL
    SELECT '2017-12-31' :: TIMESTAMP
)

SELECT d AS "Date"
	,DAYNAME(d) AS "Day"
    ,DAYOFWEEK(d) AS "DOW"
	,DATE_TRUNC('week', d) AS "Trunc Date"
	,DAYNAME("Trunc Date") AS "Trunc Day"
	,LAST_DAY(d, 'week') AS "Last DOW Date"
	,DAYNAME("Last DOW Date") AS "Last DOW Day"
    ,DATEDIFF('week', '2017-01-01', d) AS "Weeks Diff from 2017-01-01 to Date"
FROM date_data
;
