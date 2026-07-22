-- Test that row counts of two tables are equal

-- Requires table1_name, table2_name

-- This could be used to test the HK relationship from a hub to a satellite and from a satellite back to a hub; from a link to an effectivity satellite and from an effectivity satellite back to a link

WITH table1(id, colour) AS (
    SELECT 11, 'red'
    UNION ALL
    SELECT 12, 'blue'
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

    SELECT table1_count FROM table1_selection
    EXCEPT
    SELECT table2_count FROM table2_selection
)

SELECT * FROM test_selection

