-- Test that table1 rowcount <= table2 rowcount

-- Requires table1_name, table2_name

-- This is an additional check for hub --> link, link --> eff sat, hub --> sat, hub --> mas sat relationships

WITH table1(id, colour) AS (
    SELECT 11, 'red'
    UNION ALL
    SELECT 12, 'blue'
    -- UNION ALL
    -- SELECT 13, 'white'
),

table2(id, colour) AS (
    SELECT 11, 'blue'
    UNION ALL
    SELECT 12, 'red'
    -- UNION ALL
    -- SELECT 13, 'white'
),

table1_selection AS (
    SELECT COUNT(*) AS table1_count
    FROM table1
),

table2_selection as (
    SELECT COUNT(*) AS table2_count
    FROM table2
),

test_selection AS (

    SELECT
        table1_count
        ,table2_count
        ,COALESCE(table1_count, 0) - COALESCE(table2_count, 0) AS difference
    FROM table1_selection
    CROSS JOIN table2_selection
)

SELECT * FROM test_selection
WHERE difference > 0
;
