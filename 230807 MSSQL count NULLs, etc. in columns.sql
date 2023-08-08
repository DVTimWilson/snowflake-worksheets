--DECLARE @sql nvarchar(max) =
--(

-- USE databasename

    SELECT STRING_AGG(TableQuery, N' UNION ALL ') AS query_to_run
    FROM (
        SELECT N'
SELECT
  TableName
  ,TotalRows
  ,SUBSTRING(pCol, 2, CHARINDEX(''__'', pCol) - 2) AS ColName
  ,CAST(SUBSTRING(pCol, CHARINDEX(''__'', pCol) + 2, 99) AS int) AS ColPos
  ,NullCount
  ,CAST(CAST(NullCount AS decimal(12,2)) / NULLIF(CAST(TotalRows AS decimal(12,2)),0) * 100.00 AS decimal(12,2)) AS NullPct
  ,CASE WHEN NullCount = TotalRows THEN ''Y'' ELSE '''' END AS AllNull
  ,UniqueCount
  ,CAST(CAST(UniqueCount AS decimal(12,2)) / NULLIF(CAST(TotalRows AS decimal(12,2)),0) * 100.00 AS decimal(12,2)) AS UniquePct
  ,CASE WHEN UniqueCount = TotalRows THEN ''Y'' ELSE '''' END AS AllUnique
  ,ExampleData
FROM (
    SELECT
      TableName = ' + QUOTENAME(t.name, '''') + N',
      TotalRows = COUNT(*),
      ' + STRING_AGG(CAST(QUOTENAME('p' + c.name + '__' + CAST(c.column_id AS varchar(10))) + ' = COUNT(*) - COUNT(' + QUOTENAME(c.name) + ')' AS nvarchar(max)), ',') + N',
      ' + STRING_AGG(CAST(QUOTENAME('q' + c.name + '__' + CAST(c.column_id AS varchar(10))) + ' = CAST(ISNULL((SELECT TOP 1 ' + QUOTENAME(c.name) + ' FROM ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) + ' WHERE  ' + QUOTENAME(c.name) + '  IS NOT NULL), '''') AS nvarchar(max))' AS nvarchar(max)), ',') + N',
      ' + STRING_AGG(CAST(QUOTENAME('r' + c.name + '__' + CAST(c.column_id AS varchar(10))) + ' = COUNT(DISTINCT ' + QUOTENAME(c.name) + ')' AS nvarchar(max)), ',') + N'
    FROM ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) + N'
) t
UNPIVOT (NullCount FOR pCol IN 
    (' + STRING_AGG(CAST(QUOTENAME('p' + c.name + '__' + CAST(c.column_id AS varchar(10))) AS nvarchar(max)), ',') + N')
) p
UNPIVOT (ExampleData FOR qCol IN 
    (' + STRING_AGG(CAST(QUOTENAME('q' + c.name + '__' + CAST(c.column_id AS varchar(10))) AS nvarchar(max)), ',') + N')
) q
UNPIVOT (UniqueCount FOR rCol IN 
    (' + STRING_AGG(CAST(QUOTENAME('r' + c.name + '__' + CAST(c.column_id AS varchar(10))) AS nvarchar(max)), ',') + N')
) r
WHERE CAST(SUBSTRING(pCol, CHARINDEX(''__'', pCol) + 2, 99) AS int) = CAST(SUBSTRING(qCol, CHARINDEX(''__'', qCol) + 2, 99) AS int)
AND   CAST(SUBSTRING(pCol, CHARINDEX(''__'', pCol) + 2, 99) AS int) = CAST(SUBSTRING(rCol, CHARINDEX(''__'', rCol) + 2, 99) AS int)
'

        FROM sys.tables AS t
        JOIN sys.columns c ON c.object_id = t.object_id
--      WHERE t.name LIKE '%tablename%'   -- decide if you want this filter
--                                        -- you may also want AND c.is_nullable = 1
        GROUP BY t.object_id, t.name, t.schema_id

    ) AS t(TableQuery)

--);

--PRINT @sql;  -- for testing