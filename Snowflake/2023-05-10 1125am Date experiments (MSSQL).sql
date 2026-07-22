-- MSSQL
WITH date_data(row_id, row_datestamp) AS (
    SELECT 1, CAST('2016-12-31' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-01' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-02' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-02' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-03' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-04' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-01-05' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-12-30' AS datetime2)
    UNION ALL
    SELECT 1, CAST('2017-12-31' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2016-12-31' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-01-01' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-01-02' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-01-03' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-01-04' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-01-05' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-12-30' AS datetime2)
    UNION ALL
    SELECT 2, CAST('2017-12-31' AS datetime2)
),

epoch_timestamp AS (
    SELECT *
        ,DATEDIFF(s, '1970-01-01 00:00:00', row_datestamp) AS row_epoch_timestamp
    FROM date_data
),

avg_calc AS (
    SELECT *
        ,AVG(CAST(row_epoch_timestamp AS bigint)) OVER (PARTITION BY row_id) AS row_epoch_avg
    FROM epoch_timestamp
),

median_calc AS (
    SELECT *
        ,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY row_epoch_timestamp) OVER (PARTITION BY row_id) AS row_epoch_median_disc
        ,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY row_epoch_timestamp) OVER (PARTITION BY row_id) AS row_epoch_median_cont
    FROM avg_calc
),

mode_calc AS (
    SELECT
        row_id
        ,MAX(row_epoch_timestamp) AS row_epoch_mode
    FROM
    (
    SELECT
        row_id
        ,row_epoch_timestamp
--      ,COUNT(row_epoch_timestamp) AS row_epoch_count
        ,DENSE_RANK() OVER (PARTITION BY row_id ORDER BY COUNT(row_epoch_timestamp) DESC) AS row_epoch_rank
    FROM median_calc
    GROUP BY row_id, row_epoch_timestamp
    ) AS x
    WHERE x.row_epoch_rank = 1
    GROUP BY row_id
    HAVING COUNT(*) = 1
)

SELECT
    median_calc.row_id
    ,row_datestamp
    ,DATEADD(s, row_epoch_avg, '1970-01-01 00:00:00') AS row_datestamp_avg
    ,DATEADD(s, row_epoch_median_disc, '1970-01-01 00:00:00') AS row_datestamp_median_disc
    ,DATEADD(s, row_epoch_median_cont, '1970-01-01 00:00:00') AS row_datestamp_median_cont
    ,DATEADD(s, row_epoch_mode, '1970-01-01 00:00:00') AS row_datestamp_mode
FROM median_calc
LEFT OUTER JOIN mode_calc
ON median_calc.row_id = mode_calc.row_id
