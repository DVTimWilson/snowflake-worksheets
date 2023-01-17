WITH t1(v1, v2) AS (
    SELECT 1, 2
),
t2(w1, w2) AS (
    SELECT v1 * 2, v2 * 2
    FROM t1
)
SELECT *
FROM t1, t2
;

WITH t(v) AS (
    SELECT 1
    UNION ALL
    SELECT v + 1 
    FROM t
)
SELECT v
FROM t
LIMIT 10
;