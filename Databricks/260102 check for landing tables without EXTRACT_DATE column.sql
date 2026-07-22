--
-- 02/02/2026  TW  Check for landing tables without EXTRACT_DATE column
--

-- Check for tables without an EXTRACT_DATE column
SELECT DISTINCT c1.table_catalog, c1.table_schema, c1.table_name
FROM system.information_schema.columns AS c1

LEFT ANTI JOIN system.information_schema.columns AS c2
ON c1.table_catalog = c2.table_catalog
AND c1.table_schema = c2.table_schema
AND c1.table_name = c2.table_name
AND UPPER(c2.column_name) = 'EXTRACT_DATE'

WHERE 1=1
AND c1.table_catalog = 'landing'
AND c1.table_schema  NOT IN ('backup', 'default', 'information_schema', 'load_test', 'raw_baq_explore')

ORDER BY table_catalog, table_schema, table_name
;