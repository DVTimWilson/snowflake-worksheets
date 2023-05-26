-- input
SET sch_name = 'PRISM_MCQ';
SET tab_name = 'MCQ_DECISION_CODE';

SELECT
     LISTAGG(c.COLUMN_NAME, ', ') WITHIN GROUP(ORDER BY c.COLUMN_NAME) AS column_list
    ,ANY_VALUE(c.TABLE_SCHEMA || '.' || c.TABLE_NAME) AS full_table_name
    ,LISTAGG(REPLACE(SPACE(6) || ',total_rows - COUNT(<col_name>) AS <col_name>' 
                              || CHAR(13)
             , '<col_name>', c.COLUMN_NAME), '') 
     WITHIN GROUP(ORDER BY COLUMN_NAME) AS column_count_list

    ,REPLACE(REPLACE(REPLACE(
'WITH cte AS (
  SELECT
      COUNT(*) AS total_rows
<column_count_list>
  FROM <table_name>
)
SELECT COLUMN_NAME, NULLS_COLUMN_COUNT
FROM cte
UNPIVOT (NULLS_COLUMN_COUNT FOR COLUMN_NAME IN (<column_list>))
ORDER BY COLUMN_NAME;'
    ,'<column_count_list>',     column_count_list)
    ,'<table_name>',            full_table_name)
    ,'<column_list>',           column_list) AS query_to_run

FROM INFORMATION_SCHEMA.COLUMNS c
WHERE TABLE_SCHEMA = UPPER($sch_name)
  AND TABLE_NAME = UPPER($tab_name)
;

WITH cte AS (   SELECT       COUNT(*) AS total_rows       ,total_rows - COUNT(DECISION_CODE) AS DECISION_CODE       ,total_rows - COUNT(DECISION_DESCRIPTION) AS DECISION_DESCRIPTION       ,total_rows - COUNT(VALID_FROM) AS VALID_FROM       ,total_rows - COUNT(VALID_TO) AS VALID_TO   FROM PRISM_MCQ.MCQ_DECISION_CODE ) SELECT TABLE_NAME, COLUMN_NAME, NULLS_COLUMN_COUNT FROM cte UNPIVOT (NULLS_COLUMN_COUNT FOR COLUMN_NAME IN (DECISION_CODE, DECISION_DESCRIPTION, VALID_FROM, VALID_TO)) ORDER BY COLUMN_NAME;


-- Better
SELECT query_to_run || ';'
FROM (
    SELECT LISTAGG(TableQuery, ' UNION ALL ') AS query_to_run
    FROM (
        SELECT '
    SELECT
      TableName
      ,TotalRows
      ,Col
      ,NullCount
      ,CAST(CAST(NullCount AS DECIMAL(12,2)) / NULLIF(CAST(TotalRows AS DECIMAL(12,2)),0) * 100.00 AS DECIMAL(12,2)) AS NullPct
    FROM (
        SELECT
          ''' || t.TABLE_NAME || ''' AS TableName,
          COUNT(*) AS TotalRows,
          ' || LISTAGG(CAST('COUNT(*) - COUNT(' || c.COLUMN_NAME || ') AS ' || c.COLUMN_NAME AS varchar()), ',') || '
        FROM ' || t.TABLE_SCHEMA || '.' || t.TABLE_NAME || '
        ) AS t
    UNPIVOT (NullCount FOR Col IN 
        (' || LISTAGG(CAST(c.COLUMN_NAME AS varchar()), ',') || ')
    ) AS p'
    
            FROM DEV_DATA_VAULT_DB.INFORMATION_SCHEMA.TABLES t
            JOIN INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
            WHERE t.TABLE_SCHEMA = 'TWILSON_RAW_VAULT' AND t.TABLE_NAME LIKE '%DORI%'
            GROUP BY t.TABLE_NAME, t.TABLE_SCHEMA
    
        ) AS t(TableQuery)
) AS generate
;

