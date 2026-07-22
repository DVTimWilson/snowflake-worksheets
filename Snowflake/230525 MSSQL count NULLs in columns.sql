--DECLARE @sql nvarchar(max) =
--(

-- USE databasename

    SELECT STRING_AGG(TableQuery, N' UNION ALL ')
    FROM (
        SELECT N'
SELECT
  TableName
  ,TotalRows
  ,Col
  ,NullCount
  ,CAST(CAST(NullCount AS DECIMAL(12,2)) / NULLIF(CAST(TotalRows AS DECIMAL(12,2)),0) * 100.00 AS DECIMAL(12,2)) AS NullPct
FROM (
    SELECT
      TableName = ' + QUOTENAME(t.name, '''') + N',
      TotalRows = COUNT(*),
      ' + STRING_AGG(CAST(QUOTENAME(c.name) + ' = COUNT(*) - COUNT(' + QUOTENAME(c.name) + ')' AS nvarchar(max)), ',') + N'
    FROM ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) + N'
) t
UNPIVOT (NullCount FOR Col IN 
    (' + STRING_AGG(CAST(QUOTENAME(c.name) AS nvarchar(max)), ',') + N')
) p'

        FROM sys.tables t
        JOIN sys.columns c ON c.object_id = t.object_id
--      WHERE t.name LIKE '%tablename%'   -- decide if you want this filter
--                                        -- you may also want AND c.is_nullable = 1
        GROUP BY t.object_id, t.name, t.schema_id

    ) AS t(TableQuery)

--);
--PRINT @sql;  -- for testing