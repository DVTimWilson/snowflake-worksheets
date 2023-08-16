WITH example_data (date, amount) AS (
    SELECT *
    FROM VALUES
        (TO_DATE('2023-08-01'), 73.25)
        ,(TO_DATE('2023-08-02'), 48.12)
        ,(TO_DATE('2023-08-03'), 15.13)
        ,(TO_DATE('2023-08-03'), 58.37)
        ,(TO_DATE('2023-08-04'), 47.54)
        ,(TO_DATE('2023-08-05'), 45.29)
)

SELECT
    date
    ,amount
    ,SUM(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ROWS_total
    ,SUM(amount) OVER (ORDER BY date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RANGE_total
    ,SUM(amount) OVER (ORDER BY date) AS DEFAULT_total
FROM example_data
;