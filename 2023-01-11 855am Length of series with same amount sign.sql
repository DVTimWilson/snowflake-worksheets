WITH transactions(id, value_date, amount, expected_length) AS (
    SELECT 9997, '2022-03-18' :: DATE, 99.17, 2
    UNION ALL
    SELECT 9981, '2022-03-16' :: DATE, 71.44, 2
    UNION ALL
    SELECT 9979, '2022-03-16' :: DATE, -94.60, 3
    UNION ALL
    SELECT 9977, '2022-03-16' :: DATE, -6.96, 3
    UNION ALL
    SELECT 9971, '2022-03-15' :: DATE, -65.95, 3
    UNION ALL
    SELECT 9964, '2022-03-15' :: DATE, 15.13, 2
    UNION ALL
    SELECT 9962, '2022-03-15' :: DATE, 17.47, 2
    UNION ALL
    SELECT 9960, '2022-03-15' :: DATE, -3.55, 1
    UNION ALL
    SELECT 9959, '2022-03-14' :: DATE, 32.00, 1
),

transactions_rn AS (
    SELECT
        id
        ,value_date
        ,amount
        ,expected_length
        ,SIGN(amount) AS amount_sign
        ,ROW_NUMBER() OVER(ORDER BY id DESC) AS rn
    FROM transactions
),

transactions_lowhigh AS (
    SELECT
        *
        ,CASE WHEN COALESCE(LAG(amount_sign) OVER (ORDER BY id DESC), 0) != amount_sign
            THEN rn END AS low1
        ,CASE WHEN COALESCE(LEAD(amount_sign) OVER (ORDER BY id DESC), 0) != amount_sign
            THEN rn END AS high1
    FROM transactions_rn
),    

transactions_lowhighall AS (
    SELECT
        *
        ,LAST_VALUE(low1) IGNORE NULLS OVER(
            ORDER BY id DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS low2
        ,FIRST_VALUE(high1) IGNORE NULLS OVER(
            ORDER BY id DESC
            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
            ) AS high2
    FROM transactions_lowhigh
),

transactions_length AS (
    SELECT
        *
        ,high2 - low2 + 1 AS length
    FROM transactions_lowhighall
)

--SELECT * FROM transactions
--SELECT * FROM transactions_rn
--SELECT * FROM transactions_lowhigh
--SELECT * FROM transactions_lowhighall
SELECT * FROM transactions_length
ORDER BY id DESC
;







WITH transactions(id, value_date, amount, expected_length) AS (
    SELECT 9997, '2022-03-18' :: DATE, 99.17, 2
    UNION ALL
    SELECT 9981, '2022-03-16' :: DATE, 71.44, 2
    UNION ALL
    SELECT 9979, '2022-03-16' :: DATE, -94.60, 3
    UNION ALL
    SELECT 9977, '2022-03-16' :: DATE, -6.96, 3
    UNION ALL
    SELECT 9971, '2022-03-15' :: DATE, -65.95, 3
    UNION ALL
    SELECT 9964, '2022-03-15' :: DATE, 15.13, 2
    UNION ALL
    SELECT 9962, '2022-03-15' :: DATE, 17.47, 2
    UNION ALL
    SELECT 9960, '2022-03-15' :: DATE, -3.55, 1
    UNION ALL
    SELECT 9959, '2022-03-14' :: DATE, 32.00, 1
)

SELECT *
FROM transactions
MATCH_RECOGNIZE(
    ORDER BY id DESC
    MEASURES
        FINAL COUNT(*) AS actual_length
    ALL ROWS PER MATCH
    PATTERN ( (a a*) | (b b*) )
    DEFINE
        a AS SIGN(amount) = -1,
        b AS SIGN(amount) =  1
)
;




