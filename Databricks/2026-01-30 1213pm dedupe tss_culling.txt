--
-- 30/01/2026  TW dedupe table landing.operations_files.tss_culling
--

-- Backup
CREATE OR REPLACE TABLE landing.backup.tss_culling_20260130
AS SELECT * FROM landing.operations_files.tss_culling
;

-- Check
SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date ASC) = 1
EXCEPT
SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date DESC) = 1
;

SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date DESC) = 1
EXCEPT
SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date ASC) = 1
;

-- Create deduped tables
CREATE OR REPLACE TABLE landing.operations_files.tss_culling_clean_earliest
AS 
SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date ASC) = 1
;

CREATE OR REPLACE TABLE landing.operations_files.tss_culling_clean_latest
AS 
SELECT *
FROM landing.operations_files.tss_culling
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date DESC) = 1
;

-- Agreed to use _clean_latest
CREATE OR REPLACE TABLE landing.operations_files.tss_culling
AS 
SELECT *
FROM landing.operations_files.tss_culling_clean_latest
QUALIFY ROW_NUMBER() OVER (PARTITION BY Company, Customer, Cost, PickupDate, Trailer, TotalTires, ToInspect, Casings ORDER BY Extract_Date DESC) = 1
;

-- DROP TABLE landing.operations_files.tss_culling_clean_earliest
-- ;

-- DROP TABLE landing.operations_files.tss_culling_clean_latest
-- ;

-- Change owner of landing.operations_files.tss_culling to workato_admin using the GUI