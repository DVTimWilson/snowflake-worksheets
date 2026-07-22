--
-- 23/01/2026  TW  check source freshness
--

-- ==========================================================
-- Check max EXTRACT_DATE in all landing and psa tables
-- Select all the statements and run in one go
-- ==========================================================

DECLARE OR REPLACE VARIABLE v_sql STRING;

-- Build the SQL (one SELECT per column; UNION ALL)
SET VAR v_sql = (
--  SELECT CONCAT_WS(' UNION ALL ', ARRAY_AGG(stmt))
  SELECT CONCAT(CONCAT_WS(' UNION ALL ', ARRAY_AGG(stmt)), ' ORDER BY table_catalog ASC, max_extract_date ASC, table_name ASC')
  FROM (
    SELECT 
      CONCAT("SELECT '", table_catalog, "' AS table_catalog, '", table_schema, "' AS table_schema, '", table_name, "' AS table_name, MAX(EXTRACT_DATE) AS max_extract_date FROM ", table_catalog, ".", table_schema, ".", table_name) AS stmt
    FROM (
      SELECT table_catalog, table_schema, table_name
      FROM (
        -- psa tables
        SELECT table_catalog
        , table_schema
        , table_name
        FROM system.information_schema.columns
        WHERE table_catalog = 'psa'
        AND table_schema != 'backup'
        AND table_name ILIKE 'psa_%'
        AND NOT table_name ILIKE '%_bak'

        UNION ALL
        
        -- landing tables with an EXTRACT_DATE column
        SELECT c1.table_catalog, c1.table_schema, c1.table_name
        FROM system.information_schema.columns AS c1

        LEFT OUTER JOIN system.information_schema.columns AS c2
        ON c1.table_catalog = c2.table_catalog
        AND c1.table_schema = c2.table_schema
        AND c1.table_name = c2.table_name
        AND UPPER(c2.column_name) = 'EXTRACT_DATE'
        WHERE c1.table_catalog = 'landing'
        AND c1.table_schema  NOT IN ('backup', 'default', 'information_schema', 'load_test', 'raw_baq_explore')
        AND c2.column_name IS NOT NULL
      ) AS innerselect
      GROUP BY table_catalog, table_schema, table_name
      ORDER BY table_catalog, table_schema, table_name
      )
  )
)
;

-- Optional: preview the generated SQL if you need to debug
-- SELECT substring(v_sql, 1, 2048) AS sql_prefix;

EXECUTE IMMEDIATE v_sql;