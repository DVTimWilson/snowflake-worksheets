WITH logins(login_date) AS (
    SELECT '2022-03-14' :: DATE
    UNION ALL
    SELECT '2022-03-15' :: DATE
    UNION ALL
    SELECT '2022-03-16' :: DATE
    UNION ALL
    SELECT '2022-03-18' :: DATE
),

logins_rn AS (
    SELECT
        login_date
        ,ROW_NUMBER() OVER (ORDER BY login_date) AS rn
    FROM logins
),

logins_grp AS (
    SELECT
        login_date
        ,rn
        ,login_date - ROW_NUMBER() OVER (ORDER BY login_date) AS grp
    FROM logins_rn
),

logins_length AS (
    SELECT
        MIN(login_date) AS min_login_date
        ,MAX(login_date) AS max_login_date
        ,MAX(login_date) - MIN(login_date) + 1 AS length
    FROM logins_grp
    GROUP BY grp
)

SELECT * FROM logins_rn
--SELECT * FROM logins_grp
--SELECT * FROM logins_length
;


























WITH logins(login_date) AS (
    SELECT '2022-03-14' :: DATE
    UNION ALL
    SELECT '2022-03-15' :: DATE
    UNION ALL
    SELECT '2022-03-16' :: DATE
    UNION ALL
    SELECT '2022-03-18' :: DATE
    -- UNION ALL
    -- SELECT '2022-03-21' :: DATE
    -- UNION ALL
    -- SELECT '2022-03-22' :: DATE
)

SELECT *
FROM logins
MATCH_RECOGNIZE(
    ORDER BY login_date
    MEASURES
        FINAL MIN(login_date) AS min_date,
        FINAL MAX(login_date) AS max_date,
        FINAL COUNT(*) AS length
    --ALL ROWS PER MATCH
    PATTERN( a b* )
    DEFINE
        a AS login_date != LAG(login_date) + 1 OR LAG(login_date) IS NULL,
        b AS login_date <= LAG(login_date) + 1
)
;
