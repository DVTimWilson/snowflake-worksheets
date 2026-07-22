--------------------------------------------------
--
--  (C) Copyright DataVaultAlliance Holdings LLC, 2022
--
-- BASELINE EXAMPLE SCRIPTS
-- Author: Dan Linstedt, Cindi Meyersohn
-- Updated: 14 January 2022
--
-- PURPOSE: this script contains the STAGE LEVEL 2
--   to RAW DATA VAULT objects data movement scripts 
--   used in the VTCP BASELINE EXAMPLE compliance objects.
--
-- insert into stage level 2 from stage level 1
-- and 
-- insert into raw data vault from stage level 2
--
--------------------------------------------------


--------------- 01_source_employee ---------------- 


drop view if exists DBTVAULT_DEV.BMC_ERWIN.v_stg_01_source_employee_l2;
create or replace view DBTVAULT_DEV.BMC_ERWIN.v_stg_01_source_employee_l2
( 
nationalidnumber,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
ldts,
employee_hk,
employee_hdiff,
rsrc
)
as
(
Select
        cast(coalesce(trim(C_CUSTKEY),'') as VARCHAR()) as nationalidnumber,
        N_NATIONKEY,
        C_NAME,
        C_ADDRESS,
        C_PHONE,
        C_ACCTBAL,
        C_MKTSEGMENT,
        C_COMMENT,
        current_timestamp AS  ldts,
        CAST(MD5(coalesce(trim(C_CUSTKEY),'-1')) AS hashDT) as employee_hk ,
        CAST(MD5(coalesce(cast(N_NATIONKEY as varchar(15)),'') || 
        || coalesce(C_NAME,'') || 
        || coalesce(C_ADDRESS,'') || 
        || coalesce(C_PHONE,'') || 
        || coalesce(cast(C_ACCTBAL as varchar(15)),'') || 
        || coalesce(C_MKTSEGMENT,'') || 
        || coalesce(C_COMMENT,) AS hashDT) as  employee_hdiff,
        'Model5.TPCH_SF1.CUSTOMER' AS  rsrc

from TPCH_SF1.CUSTOMER
TPCH_SF1 
 );


truncate table DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2;

insert into DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2( 
nationalidnumber,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
ldts,
employee_hk,
employee_hdiff,
rsrc
)
Select
nationalidnumber,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
ldts,
employee_hk,
employee_hdiff,
rsrc
from DBTVAULT_DEV.BMC_ERWIN.v_stg_01_source_employee_l2;


drop view if exists DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_h_TO_stg_01_source_employee_l2;

create or replace view DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_h_TO_stg_01_source_employee_l2
(
employee_hk,
rsrc,
nationalidnumber,
ldts
)
as
(
select distinct 
stg.employee_hk,
stg.rsrc,
stg.nationalidnumber,
current_timestamp as ldts
 FROM DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2 as stg
		LEFT OUTER JOIN DBTVAULT_DEV.BMC_ERWIN.rv_employee_h as hub ON (stg.employee_hk=hub.employee_hk)
		WHERE hub.employee_hk IS NULL
);

insert into DBTVAULT_DEV.BMC_ERWIN.rv_employee_h
(
employee_hk,
rsrc,
nationalidnumber,
ldts
)
 Select 
employee_hk,
rsrc,
nationalidnumber,
ldts

from DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_h_TO_stg_01_source_employee_l2;


drop view if exists DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_hsat_TO_stg_01_source_employee_l2;

create or replace view DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_hsat_TO_stg_01_source_employee_l2
(
employee_hdiff,
rsrc,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
employee_hk,
ldts
)
as
(
select distinct 
stg.employee_hdiff,
stg.rsrc,
stg.N_NATIONKEY,
stg.C_NAME,
stg.C_ADDRESS,
stg.C_PHONE,
stg.C_ACCTBAL,
stg.C_MKTSEGMENT,
stg.C_COMMENT,
stg.employee_hk,
current_timestamp as ldts
 FROM DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2 as stg
		LEFT OUTER JOIN DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat as sat ON (stg.employee_hk=sat.employee_hk
		 AND (sat.ldts = (SELECT MAX(Z.ldts)
						 FROM DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat Z
						 WHERE Z.employee_hk=sat.employee_hk)) 
)
WHERE 
	( sat.employee_hk IS NULL 	 
			OR (stg.employee_hdiff != sat.employee_hdiff
	AND stg.employee_hk=sat.employee_hk))
);

insert into DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat
(
employee_hdiff,
rsrc,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
employee_hk,
ldts
)
 Select 
employee_hdiff,
rsrc,
N_NATIONKEY,
C_NAME,
C_ADDRESS,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT,
employee_hk,
ldts

from DBTVAULT_DEV.BMC_ERWIN.v_rv_employee_hsat_TO_stg_01_source_employee_l2;


