USE DATABASE TIM_WILSON
;

USE SCHEMA RAW_VAULT
;

SET ROW_LIMIT = 100000;
SELECT query_to_run || ' ORDER BY TableName, ColPos;'
FROM (
    SELECT LISTAGG(TableQuery, ' UNION ALL ') AS query_to_run
    FROM (
        SELECT '
    SELECT
      TableName
      ,TotalRows
      ,SUBSTRING(pCol, 2, CHARINDEX(''__'', pCol) - 2) AS ColName
      ,CAST(SUBSTRING(pCol, CHARINDEX(''__'', pCol) + 2) as INTEGER) AS ColPos
      ,NullCount
      ,CAST(CAST(NullCount AS DECIMAL(12,2)) / NULLIF(CAST(TotalRows AS DECIMAL(12,2)),0) * 100.00 AS DECIMAL(12,2)) AS NullPct
      ,CASE WHEN NullCount = TotalRows THEN ''Y'' ELSE '''' END AS AllNull
      ,UniqueCount
      ,CAST(CAST(UniqueCount AS DECIMAL(12,2)) / NULLIF(CAST(' || $ROW_LIMIT || ' AS DECIMAL(12,2)),0) * 100.00 AS DECIMAL(12,2)) AS UniquePct
      ,CASE WHEN UniqueCount = ' || $ROW_LIMIT || ' THEN ''Y'' ELSE '''' END AS AllUnique
    FROM (
        SELECT
          ''' || t.TABLE_NAME || ''' AS TableName,
          COUNT(*) AS TotalRows,
          ' || LISTAGG('COUNT(*) - COUNT("' || c.COLUMN_NAME || '") AS "p' || c.COLUMN_NAME || '__' || c.ORDINAL_POSITION, '",') || '",

          ' || LISTAGG('(SELECT COUNT(DISTINCT "' || c.COLUMN_NAME || '") FROM (SELECT "' || c.COLUMN_NAME || '" FROM ' || t.TABLE_SCHEMA || '.' || t.TABLE_NAME || ' LIMIT ' || $ROW_LIMIT || ')) AS "r' || c.COLUMN_NAME || '__' || c.ORDINAL_POSITION, '",') || '"

          FROM ' || t.TABLE_SCHEMA || '.' || t.TABLE_NAME || '
        ) AS t

    UNPIVOT (NullCount FOR pCol IN 
        (' || LISTAGG('"p' || CAST(c.COLUMN_NAME AS varchar()) || '__' || CAST(c.ORDINAL_POSITION AS varchar()), '",') || '")
    ) AS p

    UNPIVOT (UniqueCount FOR rCol IN 
        (' || LISTAGG('"r' || CAST(c.COLUMN_NAME AS varchar()) || '__' || CAST(c.ORDINAL_POSITION AS varchar()), '",') || '")
    ) AS r

    WHERE CAST(SUBSTRING(pCol, CHARINDEX(''__'', pCol) + 2) AS INTEGER) = CAST(SUBSTRING(rCol, CHARINDEX(''__'', rCol) + 2) AS INTEGER)'

            FROM TIM_WILSON.INFORMATION_SCHEMA.TABLES t
            INNER JOIN TIM_WILSON.INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
            WHERE t.TABLE_SCHEMA = 'RAW_VAULT'
            AND t.TABLE_NAME = 'S_ORDERS'
            GROUP BY t.TABLE_NAME, t.TABLE_SCHEMA
    
        ) AS t(TableQuery)
) AS generate
;