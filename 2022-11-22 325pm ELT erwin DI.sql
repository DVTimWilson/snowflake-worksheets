CREATE SCHEMA STAGING
;

CREATE SCHEMA VAULT
;

USE DATABASE DBTVAULT_DEV;

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


--------------- MDM_ORGANISATION ---------------- 


-- drop view if exists STAGING.v_STG_MDM_ORGANISATION;
create or replace view STAGING.v_STG_MDM_ORGANISATION
( 
ORGANISATION_HSH,
ORGANISATION_HSH_DIFF,
LOAD_DTS,
RECORD_SOURCE,
BKCC,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID
)
as
(
Select
        CAST(MD5(coalesce(trim(ID),'-1')) AS VARCHAR(32)) as ORGANISATION_HSH ,
        CAST(MD5(coalesce(ACCOUNTNUMBER,'') || '||'
        || coalesce(ADDITIONALEMAILADDRESSES,'') || '||'
        || coalesce(ALLOWINVOICEEDIT,'') || '||'
        || coalesce(AUTOPAY,'') || '||'
        || coalesce(cast(BALANCE as varchar(15)),'') || '||'
        || coalesce(BATCH,'') || '||'
        || coalesce(BCDSETTINGOPTION,'') || '||'
        || coalesce(cast(BILLCYCLEDAY as varchar(15)),'') || '||'
        || coalesce(BILLTOID,'') || '||'
        || coalesce(COMMUNICATIONPROFILEID,'') || '||'
        || coalesce(CREATEDBYID,'') || '||'
        || coalesce(cast(CREATEDDATE as varchar(15)),'') || '||'
        || coalesce(cast(CREDITBALANCE as varchar(15)),'') || '||'
        || coalesce(CREDITMEMOTEMPLATEID,'') || '||'
        || coalesce(CRMID,'') || '||'
        || coalesce(CURRENCY,'') || '||'
        || coalesce(CURRENCYCODE,'') || '||'
        || coalesce(CUSTOMERSERVICEREPNAME,'') || '||'
        || coalesce(DEBITMEMOTEMPLATEID,'') || '||'
        || coalesce(DEFAULTPAYMENTMETHODID,'') || '||'
        || coalesce(DELETED,'') || '||'
        || coalesce(trim(ID),'-1' ) || '||'
        || coalesce(INVOICEDELIVERYPREFSEMAIL,'') || '||'
        || coalesce(INVOICEDELIVERYPREFSPRINT,'') || '||'
        || coalesce(INVOICETEMPLATEID,'') || '||'
        || coalesce(cast(LASTINVOICEDATE as varchar(15)),'') || '||'
        || coalesce(cast(MRR as varchar(15)),'') || '||'
        || coalesce(NAME,'') || '||'
        || coalesce(NOTES,'') || '||'
        || coalesce(PARENTID,'') || '||'
        || coalesce(PAYMENTGATEWAY,'') || '||'
        || coalesce(PAYMENTTERM,'') || '||'
        || coalesce(PURCHASEORDERNUMBER,'') || '||'
        || coalesce(SALESREPNAME,'') || '||'
        || coalesce(SEQUENCESETID,'') || '||'
        || coalesce(SOLDTOID,'') || '||'
        || coalesce(STATUS,'') || '||'
        || coalesce(TAXCOMPANYCODE,'') || '||'
        || coalesce(TAXEXEMPTCERTIFICATEID,'') || '||'
        || coalesce(TAXEXEMPTCERTIFICATETYPE,'') || '||'
        || coalesce(TAXEXEMPTDESCRIPTION,'') || '||'
        || coalesce(cast(TAXEXEMPTEFFECTIVEDATE as varchar(15)),'') || '||'
        || coalesce(TAXEXEMPTENTITYUSECODE,'') || '||'
        || coalesce(cast(TAXEXEMPTEXPIRATIONDATE as varchar(15)),'') || '||'
        || coalesce(TAXEXEMPTISSUINGJURISDICTION,'') || '||'
        || coalesce(TAXEXEMPTSTATUS,'') || '||'
        || coalesce(cast(TOTALDEBITMEMOBALANCE as varchar(15)),'') || '||'
        || coalesce(cast(TOTALINVOICEBALANCE as varchar(15)),'') || '||'
        || coalesce(cast(UNAPPLIEDBALANCE as varchar(15)),'') || '||'
        || coalesce(cast(UNAPPLIEDCREDITMEMOAMOUNT as varchar(15)),'') || '||'
        || coalesce(UPDATEDBYID,'') || '||'
        || coalesce(cast(UPDATEDDATE as varchar(15)),'') || '||'
        || coalesce(VATID,'') ) AS VARCHAR(32)) as  ORGANISATION_HSH_DIFF,
        CURRENT_TIMESTAMP AS  LOAD_DTS,
        'BMC_ZUORA_SNOWFLAKE.BMC_ZUORA.ACCOUNT' AS  RECORD_SOURCE,
        'ZUORA' AS BKCC,
        ACCOUNTNUMBER,
        ADDITIONALEMAILADDRESSES,
        ALLOWINVOICEEDIT,
        AUTOPAY,
        BALANCE,
        BATCH,
        BCDSETTINGOPTION,
        BILLCYCLEDAY,
        BILLTOID,
        COMMUNICATIONPROFILEID,
        CREATEDBYID,
        CREATEDDATE,
        CREDITBALANCE,
        CREDITMEMOTEMPLATEID,
        CRMID,
        CURRENCY,
        CURRENCYCODE,
        CUSTOMERSERVICEREPNAME,
        DEBITMEMOTEMPLATEID,
        DEFAULTPAYMENTMETHODID,
        DELETED,
        cast(coalesce(trim(ID),'-1') as CHAR(18)) as AccountID,
        INVOICEDELIVERYPREFSEMAIL,
        INVOICEDELIVERYPREFSPRINT,
        INVOICETEMPLATEID,
        LASTINVOICEDATE,
        MRR,
        NAME,
        NOTES,
        PARENTID,
        PAYMENTGATEWAY,
        PAYMENTTERM,
        PURCHASEORDERNUMBER,
        SALESREPNAME,
        SEQUENCESETID,
        SOLDTOID,
        STATUS,
        TAXCOMPANYCODE,
        TAXEXEMPTCERTIFICATEID,
        TAXEXEMPTCERTIFICATETYPE,
        TAXEXEMPTDESCRIPTION,
        TAXEXEMPTEFFECTIVEDATE,
        TAXEXEMPTENTITYUSECODE,
        TAXEXEMPTEXPIRATIONDATE,
        TAXEXEMPTISSUINGJURISDICTION,
        TAXEXEMPTSTATUS,
        TOTALDEBITMEMOBALANCE,
        TOTALINVOICEBALANCE,
        UNAPPLIEDBALANCE,
        UNAPPLIEDCREDITMEMOAMOUNT,
        UPDATEDBYID,
        UPDATEDDATE,
        VATID

from BMC_ZUORA.ACCOUNT 
 );


truncate table STAGING.STG_MDM_ORGANISATION;

insert into STAGING.STG_MDM_ORGANISATION( 
ORGANISATION_HSH,
ORGANISATION_HSH_DIFF,
LOAD_DTS,
RECORD_SOURCE,
BKCC,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID
)
Select
ORGANISATION_HSH,
ORGANISATION_HSH_DIFF,
LOAD_DTS,
RECORD_SOURCE,
BKCC,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID
from STAGING.v_STG_MDM_ORGANISATION;


-- drop view if exists VAULT.v_RV_ORGANISATION_HUB_TO_STG_MDM_ORGANISATION;

create or replace view VAULT.v_RV_ORGANISATION_HUB_TO_STG_MDM_ORGANISATION
(
ORGANISATION_HSH,
LOAD_DTS,
RECORD_SOURCE,
AccountID,
BKCC
)
as
(
select distinct 
STG.ORGANISATION_HSH,
CURRENT_TIMESTAMP as LOAD_DTS,
STG.RECORD_SOURCE,
STG.AccountID,
STG.BKCC
 FROM STAGING.STG_MDM_ORGANISATION as STG
		LEFT OUTER JOIN VAULT.RV_ORGANISATION_HUB as hub ON (STG.ORGANISATION_HSH=hub.ORGANISATION_HSH)
		WHERE hub.ORGANISATION_HSH IS NULL
);

insert into VAULT.RV_ORGANISATION_HUB
(
ORGANISATION_HSH,
LOAD_DTS,
RECORD_SOURCE,
AccountID,
BKCC
)
 Select 
ORGANISATION_HSH,
LOAD_DTS,
RECORD_SOURCE,
AccountID,
BKCC

from VAULT.v_RV_ORGANISATION_HUB_TO_STG_MDM_ORGANISATION;


-- drop view if exists VAULT.v_RV_ORGANISATION_MDM_SAT_TO_STG_MDM_ORGANISATION;

create or replace view VAULT.v_RV_ORGANISATION_MDM_SAT_TO_STG_MDM_ORGANISATION
(
ORGANISATION_HSH,
LOAD_DTS,
BKCC,
ORGANISATION_HSH_DIFF,
RECORD_SOURCE,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID
)
as
(
select distinct 
STG.ORGANISATION_HSH,
CURRENT_TIMESTAMP as LOAD_DTS,
STG.BKCC,
STG.ORGANISATION_HSH_DIFF,
STG.RECORD_SOURCE,
STG.ACCOUNTNUMBER,
STG.ADDITIONALEMAILADDRESSES,
STG.ALLOWINVOICEEDIT,
STG.AUTOPAY,
STG.BALANCE,
STG.BATCH,
STG.BCDSETTINGOPTION,
STG.BILLCYCLEDAY,
STG.BILLTOID,
STG.COMMUNICATIONPROFILEID,
STG.CREATEDBYID,
STG.CREATEDDATE,
STG.CREDITBALANCE,
STG.CREDITMEMOTEMPLATEID,
STG.CRMID,
STG.CURRENCY,
STG.CURRENCYCODE,
STG.CUSTOMERSERVICEREPNAME,
STG.DEBITMEMOTEMPLATEID,
STG.DEFAULTPAYMENTMETHODID,
STG.DELETED,
STG.AccountID,
STG.INVOICEDELIVERYPREFSEMAIL,
STG.INVOICEDELIVERYPREFSPRINT,
STG.INVOICETEMPLATEID,
STG.LASTINVOICEDATE,
STG.MRR,
STG.NAME,
STG.NOTES,
STG.PARENTID,
STG.PAYMENTGATEWAY,
STG.PAYMENTTERM,
STG.PURCHASEORDERNUMBER,
STG.SALESREPNAME,
STG.SEQUENCESETID,
STG.SOLDTOID,
STG.STATUS,
STG.TAXCOMPANYCODE,
STG.TAXEXEMPTCERTIFICATEID,
STG.TAXEXEMPTCERTIFICATETYPE,
STG.TAXEXEMPTDESCRIPTION,
STG.TAXEXEMPTEFFECTIVEDATE,
STG.TAXEXEMPTENTITYUSECODE,
STG.TAXEXEMPTEXPIRATIONDATE,
STG.TAXEXEMPTISSUINGJURISDICTION,
STG.TAXEXEMPTSTATUS,
STG.TOTALDEBITMEMOBALANCE,
STG.TOTALINVOICEBALANCE,
STG.UNAPPLIEDBALANCE,
STG.UNAPPLIEDCREDITMEMOAMOUNT,
STG.UPDATEDBYID,
STG.UPDATEDDATE,
STG.VATID
 FROM STAGING.STG_MDM_ORGANISATION as STG
		LEFT OUTER JOIN VAULT.RV_ORGANISATION_MDM_SAT as sat ON (STG.ORGANISATION_HSH=sat.ORGANISATION_HSH
		 AND (sat.LOAD_DTS = (SELECT MAX(Z.LOAD_DTS)
						 FROM VAULT.RV_ORGANISATION_MDM_SAT Z
						 WHERE Z.ORGANISATION_HSH=sat.ORGANISATION_HSH)) 
)
WHERE 
	( sat.ORGANISATION_HSH IS NULL 	 
			OR (STG.ORGANISATION_HSH_DIFF != sat.ORGANISATION_HSH_DIFF
	AND STG.ORGANISATION_HSH=sat.ORGANISATION_HSH))
);

insert into VAULT.RV_ORGANISATION_MDM_SAT
(
ORGANISATION_HSH,
LOAD_DTS,
BKCC,
ORGANISATION_HSH_DIFF,
RECORD_SOURCE,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID
)
 Select 
ORGANISATION_HSH,
LOAD_DTS,
BKCC,
ORGANISATION_HSH_DIFF,
RECORD_SOURCE,
ACCOUNTNUMBER,
ADDITIONALEMAILADDRESSES,
ALLOWINVOICEEDIT,
AUTOPAY,
BALANCE,
BATCH,
BCDSETTINGOPTION,
BILLCYCLEDAY,
BILLTOID,
COMMUNICATIONPROFILEID,
CREATEDBYID,
CREATEDDATE,
CREDITBALANCE,
CREDITMEMOTEMPLATEID,
CRMID,
CURRENCY,
CURRENCYCODE,
CUSTOMERSERVICEREPNAME,
DEBITMEMOTEMPLATEID,
DEFAULTPAYMENTMETHODID,
DELETED,
AccountID,
INVOICEDELIVERYPREFSEMAIL,
INVOICEDELIVERYPREFSPRINT,
INVOICETEMPLATEID,
LASTINVOICEDATE,
MRR,
NAME,
NOTES,
PARENTID,
PAYMENTGATEWAY,
PAYMENTTERM,
PURCHASEORDERNUMBER,
SALESREPNAME,
SEQUENCESETID,
SOLDTOID,
STATUS,
TAXCOMPANYCODE,
TAXEXEMPTCERTIFICATEID,
TAXEXEMPTCERTIFICATETYPE,
TAXEXEMPTDESCRIPTION,
TAXEXEMPTEFFECTIVEDATE,
TAXEXEMPTENTITYUSECODE,
TAXEXEMPTEXPIRATIONDATE,
TAXEXEMPTISSUINGJURISDICTION,
TAXEXEMPTSTATUS,
TOTALDEBITMEMOBALANCE,
TOTALINVOICEBALANCE,
UNAPPLIEDBALANCE,
UNAPPLIEDCREDITMEMOAMOUNT,
UPDATEDBYID,
UPDATEDDATE,
VATID

from VAULT.v_RV_ORGANISATION_MDM_SAT_TO_STG_MDM_ORGANISATION;


