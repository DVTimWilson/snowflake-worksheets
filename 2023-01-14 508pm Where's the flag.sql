WITH observations(id, colour) AS (
    SELECT 11, 'red'
    UNION ALL
    SELECT 12, 'blue'
    UNION ALL
    SELECT 13, 'white'
    UNION ALL
    SELECT 14, 'red'
    UNION ALL
    SELECT 15, 'yellow'
    UNION ALL
    SELECT 16, 'blue'
    UNION ALL
    SELECT 17, 'red'
    UNION ALL
    SELECT 18, 'white'
    UNION ALL
    SELECT 19, 'blue'
    UNION ALL
    SELECT 20, 'red'
    UNION ALL
    SELECT 21, 'white'
    UNION ALL
    SELECT 22, 'red'
    UNION ALL
    SELECT 23, 'blue'
    UNION ALL
    SELECT 24, 'blue'
    UNION ALL
    SELECT 25, 'green'
    UNION ALL
    SELECT 26, 'blue'
    UNION ALL
    SELECT 27, 'white'
    UNION ALL
    SELECT 28, 'red'
    UNION ALL
    SELECT 29, 'white'
    UNION ALL
    SELECT 30, 'red'
),

flag AS (
    SELECT *
        ,LEAD(colour) OVER (ORDER BY id) AS next_colour
        ,LEAD(colour,2) OVER (ORDER BY id) AS next_next_colour
    FROM observations
)

SELECT *
FROM flag
WHERE colour = 'red'
    AND next_colour = 'white'
    AND next_next_colour = 'blue'
;

WITH observations(id, colour) AS (
    SELECT 11, 'red'
    UNION ALL
    SELECT 12, 'blue'
    UNION ALL
    SELECT 13, 'white'
    UNION ALL
    SELECT 14, 'red'
    UNION ALL
    SELECT 15, 'yellow'
    UNION ALL
    SELECT 16, 'blue'
    UNION ALL
    SELECT 17, 'red'
    UNION ALL
    SELECT 18, 'white'
    UNION ALL
    SELECT 19, 'blue'
    UNION ALL
    SELECT 20, 'red'
    UNION ALL
    SELECT 21, 'white'
    UNION ALL
    SELECT 22, 'red'
    UNION ALL
    SELECT 23, 'blue'
    UNION ALL
    SELECT 24, 'blue'
    UNION ALL
    SELECT 25, 'green'
    UNION ALL
    SELECT 26, 'blue'
    UNION ALL
    SELECT 27, 'white'
    UNION ALL
    SELECT 28, 'red'
    UNION ALL
    SELECT 29, 'white'
    UNION ALL
    SELECT 30, 'red'
)

SELECT *
FROM observations
MATCH_RECOGNIZE(
    ORDER BY id
    MEASURES
        FINAL MIN(id) AS red_id
        ,FINAL MAX(id) AS blue_id
    ALL ROWS PER MATCH
    PATTERN(red white blue)
    DEFINE
        red AS colour = 'red'
        ,white AS colour = 'white'
        ,blue AS colour = 'blue'
)
;