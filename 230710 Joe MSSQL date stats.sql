--THE ONE TRUE QUERY Case Factor

--Mean, Median, Min, Max, Count
WITH epoch_select as (SELECT ccf.casefactorid 
	,ccf.ModifiedDate
	,CAST(DATEDIFF(s, '1970-01-01 00:00:00', ccf.ModifiedDate) AS BIGINT) as epoch_date
FROM stage.pstg_case_case_factor ccf
inner join stage.pstg_case_factor cf
    on cf.casefactorid = ccf.casefactorid
),

median as (SELECT *, 
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ModifiedDate)   
                            OVER (PARTITION BY CaseFactorId) AS MedianDisc 
	FROM epoch_select
)

select cf.casefactordescription
	,count(*) as Total_Count
	,DATEADD(s, AVG(ccf.epoch_date), '1970-01-01 00:00:00') AS Mean_Average_Date
	,MIN(ccf.ModifiedDate) as Date_of_First_Instance
	,MAX(ccf.ModifiedDate) as Date_of_Most_Recent_Instance
	,MedianDisc as Median_Date
from median as ccf
inner join stage.pstg_case_factor cf
    on cf.casefactorid = ccf.casefactorid
group by cf.casefactordescription,MedianDisc
ORDER BY cf.CaseFactorDescription
;


-- Distribution by Year
DECLARE 
    @columns NVARCHAR(MAX) = ''
	,@sql     NVARCHAR(MAX) = '';

SELECT 
    @columns += QUOTENAME(cf.casefactordescription) + ','
FROM stage.pstg_case_case_factor ccf
inner join stage.pstg_case_factor cf
    on cf.casefactorid = ccf.casefactorid
GROUP BY
	cf.casefactordescription

SET @columns = LEFT(@columns, LEN(@columns) - 1);


set @sql ='
select * from (
	select year(ccf.ModifiedDate) as Associated_Year,cf.casefactordescription
FROM stage.pstg_case_case_factor ccf
inner join stage.pstg_case_factor cf
    on cf.casefactorid = ccf.casefactorid
		) t
PIVOT(
	count(casefactordescription)
	FOR casefactordescription in ('+ @columns +')
) AS pivot_table
ORDER BY Associated_Year;';

EXECUTE sp_executesql @sql;