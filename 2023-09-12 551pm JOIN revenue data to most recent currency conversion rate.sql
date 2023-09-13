WITH currency_conversion_table (currency, date, rate) AS (
    SELECT *
    FROM VALUES
        ('USD', TO_DATE('2023-08-01'), 1.25)
        ,('USD', TO_DATE('2023-08-08'), 1.29)
        ,('USD', TO_DATE('2023-08-15'), 1.31)
        ,('PLZ', TO_DATE('2023-09-01'), 5.10)
        ,('PLZ', TO_DATE('2023-09-08'), 4.97)
        ,('PLZ', TO_DATE('2023-09-15'), 4.83)
),

revenue_data (date, currency, value) AS (
    SELECT *
    FROM VALUES
        (TO_DATE('2023-08-01'), 'USD', 10000)
        ,(TO_DATE('2023-08-11'), 'USD', 8000)
        ,(TO_DATE('2023-08-19'), 'PLZ', 27000)
        ,(TO_DATE('2023-09-21'), 'PLZ', 27000)
)

SELECT
    r.date AS rdate
    ,r.currency AS rcurrency
    ,r.value as rvalue
    ,cct.rate
    -- next 2 columns for checking only
    ,cct.date AS cdate
    ,ROW_NUMBER() OVER (PARTITION BY r.date, r.currency ORDER BY cct.date DESC) AS rn
FROM revenue_data AS r
LEFT OUTER JOIN currency_conversion_table AS cct
ON r.currency = cct.currency
AND cct.date <= r.date
QUALIFY ROW_NUMBER() OVER (PARTITION BY r.date, r.currency ORDER BY cct.date DESC) = 1
ORDER BY r.date, r.currency
;
