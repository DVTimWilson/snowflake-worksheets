IF OBJECT_ID('tempdb..#SqlStatement') IS NOT NULL 
Drop Table #SqlStatement 
go
IF OBJECT_ID('tempdb..#sp_who2') IS NOT NULL 
Drop Table #sp_who2
go
IF OBJECT_ID('tempdb..#temp') IS NOT NULL 
Drop Table #temp
go

set nocount on

CREATE TABLE #sp_who2 (  SPID INT,  Status VARCHAR(1000) NULL,  
Login SYSNAME NULL,  HostName SYSNAME NULL,  
BlkBy SYSNAME NULL,  DBName SYSNAME NULL,  
Command VARCHAR(5000) NULL,  CPUTime INT NULL,  
DiskIO INT NULL,  LastBatch VARCHAR(1000) NULL,  
ProgramName VARCHAR(5000) NULL,  SPID2 INT
, REQUESTID INT -- remove if running in SQL2000 environment
) 

CREATE TABLE #SqlStatement(spid int, statement varchar(8000))

CREATE TABLE #temp (x varchar(500), y int, s varchar(5000), id int identity (1,1))

INSERT #sp_who2 EXEC sp_who2 

Declare @spid varchar(10)
Declare @Statement varchar(8000)
declare @sql varchar(1000)
DECLARE SpidCursor Cursor 
FOR 
Select spid from #sp_who2
OPEN SpidCursor
FETCH NEXT FROM SpidCursor INTO @spid
WHILE @@FETCH_STATUS = 0 
BEGIN   SET @sql = 'dbcc inputbuffer (' + @spid + ')'   
insert #temp   exec (@sql)   
Insert Into #SqlStatement    
Select @spid, s  From #Temp where id = (Select max(id) from #Temp)
  FETCH NEXT FROM SpidCursor  INTO @spid
END
Close SpidCursor Deallocate SpidCursor

Select distinct B.Statement, A.* from #sp_who2 A 
Left JOIN  #SqlStatement B ON A.spid = B.spid
--order by CPUTime desc
order by DiskIO desc
 --order by A.SPID-- 11 desc
--order by lastbatch desc
--where login = 'HTA_RO'

--Drop Table #TempDrop 
--Drop Table #SqlStatement 
--Drop Table #sp_who2
--Drop Table #temp

set nocount off
go

--SELECT T0.PostCode, T0.REConstituentID, T0.RegionCodeID, T0.HVAN_Constituent_Code, T1.Easting, T1.Northing, T1.ID  FROM dbo.WH_Constituent T0, dbo.WH_RegionCode T1  WHERE T1.ID = T0.RegionCodeID and T1.ID = T0.RegionCodeID and (T0.HVAN_Constituent_Code = 