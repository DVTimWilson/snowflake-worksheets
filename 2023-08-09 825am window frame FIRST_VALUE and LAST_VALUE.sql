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

-- Note that in Snowflake for FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
-- the default wndow frame DOES NOT follow the ANSI standard

-- Also note that when using LAST_VALUE() it might be the case that
-- FIRST_VALUE() with ORDER BY ... DESC is more performant, especially at scale
-- so don't forget to test your script carefully!

SELECT
    date
    ,amount
    ,FIRST_VALUE(amount) OVER (ORDER BY date) AS FIRST_VALUE_1
    ,FIRST_VALUE(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS FIRST_VALUE_2
    ,FIRST_VALUE(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS FIRST_VALUE_3
    ,LAST_VALUE(amount) OVER (ORDER BY date) AS LAST_VALUE_1
    ,LAST_VALUE(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS LAST_VALUE_2
    ,LAST_VALUE(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LAST_VALUE_3
FROM example_data
;