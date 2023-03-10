create or replace schema BMC_ZUORA_RAW_VAULT;

create or replace TRANSIENT TABLE REF_PRODUCTRATEPLANCHARGETIER_RHUB (
	PRODUCTRATEPLANCHARGETIER_HK BINARY(16),
	ID VARCHAR(32),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(31)
);
create or replace TRANSIENT TABLE REF_PRODUCTRATEPLANCHARGETIER_ZUORA_PRODUCTRATEPLANCHARGETIER_RSAT (
	PRODUCTRATEPLANCHARGETIER_HK BINARY(16),
	PRODUCTRATEPLANCHARGETIER_HASHDIFF BINARY(16),
	ACTIVE BOOLEAN,
	CREATEDBYID VARCHAR(32),
	CREATEDDATE TIMESTAMP_TZ(9),
	CURRENCY VARCHAR(16777216),
	DELETED BOOLEAN,
	DISCOUNTAMOUNT NUMBER(22,9),
	DISCOUNTPERCENTAGE NUMBER(22,9),
	ENDINGUNIT NUMBER(22,9),
	ID VARCHAR(32),
	INCLUDEDUNITS NUMBER(22,9),
	OVERAGEPRICE NUMBER(22,9),
	PRICE NUMBER(22,9),
	PRICEFORMAT VARCHAR(16777216),
	PRODUCTRATEPLANCHARGEID VARCHAR(32),
	STARTINGUNIT NUMBER(22,9),
	TIER NUMBER(38,0),
	UPDATEDBYID VARCHAR(32),
	UPDATEDDATE TIMESTAMP_TZ(9),
	EFFECTIVE_FROM TIMESTAMP_NTZ(9),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(31)
);
create or replace TRANSIENT TABLE RV_PRODUCTRATEPLAN_HUB (
	PRODUCTRATEPLAN_HK BINARY(16),
	ID VARCHAR(32),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(21)
);
create or replace TRANSIENT TABLE RV_PRODUCTRATEPLAN_ZUORA_PRODUCTRATEPLANCHARGE_SAT (
	PRODUCTRATEPLAN_HK BINARY(16),
	PRODUCTRATEPLANCHARGE_HASHDIFF BINARY(16),
	ACCOUNTINGCODE VARCHAR(100),
	ACCOUNTRECEIVABLEACCOUNTINGCODEID VARCHAR(32),
	ADJUSTMENTLIABILITYACCOUNTINGCODEID VARCHAR(32),
	ADJUSTMENTREVENUEACCOUNTINGCODEID VARCHAR(32),
	APPLYDISCOUNTTO VARCHAR(16777216),
	BILLCYCLEDAY NUMBER(38,0),
	BILLCYCLETYPE VARCHAR(16777216),
	BILLINGPERIOD VARCHAR(16777216),
	BILLINGPERIODALIGNMENT VARCHAR(16777216),
	BILLINGTIMING VARCHAR(16777216),
	CHARGEMODEL VARCHAR(16777216),
	CHARGETYPE VARCHAR(16777216),
	CONTRACTASSETACCOUNTINGCODEID VARCHAR(32),
	CONTRACTLIABILITYACCOUNTINGCODEID VARCHAR(32),
	CONTRACTRECOGNIZEDREVENUEACCOUNTINGCODEID VARCHAR(32),
	CREATEDBYID VARCHAR(32),
	CREATEDDATE TIMESTAMP_TZ(9),
	DEFAULTQUANTITY NUMBER(22,9),
	DEFERREDREVENUEACCOUNT VARCHAR(100),
	DEFERREDREVENUEACCOUNTINGCODEID VARCHAR(32),
	DELETED BOOLEAN,
	DESCRIPTION VARCHAR(500),
	DISCOUNTCLASSID VARCHAR(32),
	DISCOUNTLEVEL VARCHAR(16777216),
	ENDDATECONDITION VARCHAR(16777216),
	ID VARCHAR(32),
	INCLUDEDUNITS FLOAT,
	LEGACYREVENUEREPORTING BOOLEAN,
	LISTPRICEBASE VARCHAR(16777216),
	MAXQUANTITY NUMBER(22,9),
	MINQUANTITY NUMBER(22,9),
	NAME VARCHAR(100),
	NUMBEROFPERIOD NUMBER(38,0),
	OVERAGECALCULATIONOPTION VARCHAR(16777216),
	OVERAGEUNUSEDUNITSCREDITOPTION VARCHAR(16777216),
	PRICECHANGEOPTION VARCHAR(16777216),
	PRICEINCREASEPERCENTAGE FLOAT,
	PRODUCTRATEPLANID VARCHAR(32),
	RATINGGROUP VARCHAR(16777216),
	RECOGNIZEDREVENUEACCOUNT VARCHAR(100),
	RECOGNIZEDREVENUEACCOUNTINGCODEID VARCHAR(32),
	REVENUERECOGNITIONRULENAME VARCHAR(50),
	REVRECCODE VARCHAR(70),
	REVRECTRIGGERCONDITION VARCHAR(32),
	SMOOTHINGMODEL VARCHAR(16777216),
	SPECIFICBILLINGPERIOD NUMBER(38,0),
	TAXABLE BOOLEAN,
	TAXCODE VARCHAR(64),
	TAXMODE VARCHAR(16777216),
	TRIGGEREVENT VARCHAR(16777216),
	UNBILLEDRECEIVABLESACCOUNTINGCODEID VARCHAR(32),
	UOM VARCHAR(50),
	UPDATEDBYID VARCHAR(32),
	UPDATEDDATE TIMESTAMP_TZ(9),
	UPTOPERIODS NUMBER(38,0),
	UPTOPERIODSTYPE VARCHAR(16777216),
	USAGERECORDRATINGOPTION VARCHAR(16777216),
	USEDISCOUNTSPECIFICACCOUNTINGCODE BOOLEAN,
	USETENANTDEFAULTFORPRICECHANGE BOOLEAN,
	WEEKLYBILLCYCLEDAY VARCHAR(16777216),
	EFFECTIVE_FROM TIMESTAMP_NTZ(9),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(27)
);
create or replace TRANSIENT TABLE RV_PRODUCTRATEPLAN_ZUORA_PRODUCTRATEPLAN_SAT (
	PRODUCTRATEPLAN_HK BINARY(16),
	PRODUCTRATEPLAN_HASHDIFF BINARY(16),
	CREATEDBYID VARCHAR(32),
	CREATEDDATE TIMESTAMP_TZ(9),
	DELETED BOOLEAN,
	DESCRIPTION VARCHAR(16777216),
	EFFECTIVEENDDATE DATE,
	EFFECTIVESTARTDATE DATE,
	ID VARCHAR(32),
	NAME VARCHAR(255),
	PRODUCTID VARCHAR(32),
	UPDATEDBYID VARCHAR(32),
	UPDATEDDATE TIMESTAMP_TZ(9),
	EFFECTIVE_FROM TIMESTAMP_NTZ(9),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(21)
);
create or replace TRANSIENT TABLE RV_PRODUCT_HAS_PRODUCT_RATE_PLAN_LNK (
	PRODUCT_HAS_PRODUCT_RATE_PLAN_HK BINARY(16),
	PRODUCTRATEPLAN_HK BINARY(16),
	PRODUCT_HK BINARY(16),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(21)
);
create or replace TRANSIENT TABLE RV_PRODUCT_HUB (
	PRODUCT_HK BINARY(16),
	ID VARCHAR(32),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(13)
);
create or replace TRANSIENT TABLE RV_PRODUCT_ZUORA_PRODUCT_SAT (
	PRODUCT_HK BINARY(16),
	PRODUCT_HASHDIFF BINARY(16),
	ALLOWFEATURECHANGES BOOLEAN,
	CATEGORY VARCHAR(100),
	CREATEDBYID VARCHAR(32),
	CREATEDDATE TIMESTAMP_TZ(9),
	DELETED BOOLEAN,
	DESCRIPTION VARCHAR(500),
	EFFECTIVEENDDATE DATE,
	EFFECTIVESTARTDATE DATE,
	ID VARCHAR(32),
	NAME VARCHAR(120),
	SKU VARCHAR(70),
	UPDATEDBYID VARCHAR(32),
	UPDATEDDATE TIMESTAMP_TZ(9),
	EFFECTIVE_FROM TIMESTAMP_NTZ(9),
	LOAD_DATETIME TIMESTAMP_NTZ(9),
	RECORD_SOURCE VARCHAR(13)
);
create or replace view RV_PRODUCT_HAS_PRODUCT_RATE_PLAN_ZUORA_PRODUCTRATEPLAN_LSAT(
	PRODUCT_HAS_PRODUCT_RATE_PLAN_HK,
	PRODUCT_HK,
	PRODUCTRATEPLAN_HK,
	START_DATE,
	END_DATE,
	EFFECTIVE_FROM,
	LOAD_DATETIME,
	RECORD_SOURCE
) as (
    -- Generated by dbtvault.



WITH source_data AS (
    SELECT a."PRODUCT_HAS_PRODUCT_RATE_PLAN_HK", a."PRODUCT_HK", a."PRODUCTRATEPLAN_HK", a."START_DATE", a."END_DATE", a."EFFECTIVE_FROM", a."LOAD_DATETIME", a."RECORD_SOURCE"
    FROM DBTVAULT_DEV.BMC_ZUORA_PRIMED_STAGING.primed_stg_zuora_productrateplan AS a
    WHERE a."PRODUCT_HK" IS NOT NULL
    AND a."PRODUCTRATEPLAN_HK" IS NOT NULL
),

records_to_insert AS (
    SELECT i."PRODUCT_HAS_PRODUCT_RATE_PLAN_HK", i."PRODUCT_HK", i."PRODUCTRATEPLAN_HK", i."START_DATE", i."END_DATE", i."EFFECTIVE_FROM", i."LOAD_DATETIME", i."RECORD_SOURCE"
    FROM source_data AS i
)

SELECT * FROM records_to_insert
  );