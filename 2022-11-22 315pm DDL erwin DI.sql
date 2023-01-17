
USE DBTVAULT_DEV;
CREATE SCHEMA STAGING
;

USE DBTVAULT_DEV;
CREATE SCHEMA VAULT
;

USE DBTVAULT_DEV;
USE SCHEMA STAGING;

DROP TABLE STAGING.STG_MDM_ORGANISATION
;

USE DBTVAULT_DEV;
USE SCHEMA VAULT;

DROP TABLE VAULT.RV_ORGANISATION_HUB
;

DROP TABLE VAULT.RV_ORGANISATION_MDM_SAT
;




USE DBTVAULT_DEV;
USE SCHEMA STAGING;

/***** Script Date: Tue Nov 22 2022 17:49:18 GMT+0000 (UTC) ******/
/****** Object:  Table STAGING.STG_MDM_ORGANISATION   *****/
CREATE OR REPLACE TABLE STAGING.STG_MDM_ORGANISATION (
    SEQ_KEY BIGINT NOT NULL,
    ORGANISATION_HSH VARCHAR(32) NOT NULL,
    ORGANISATION_HSH_DIFF VARCHAR(32) NOT NULL,
    LOAD_DTS TIMESTAMP_NTZ NOT NULL,
    RECORD_SOURCE VARCHAR(100) NOT NULL,
    BKCC VARCHAR(10) NOT NULL,
    ACCOUNTNUMBER varchar(70) NULL,
    ADDITIONALEMAILADDRESSES varchar(1200) NULL,
    ALLOWINVOICEEDIT boolean NULL,
    AUTOPAY boolean NULL,
    BALANCE number NULL,
    BATCH varchar(20) NULL,
    BCDSETTINGOPTION varchar(16777216) NULL,
    BILLCYCLEDAY number NULL,
    BILLTOID varchar(32) NULL,
    COMMUNICATIONPROFILEID varchar(32) NULL,
    CREATEDBYID varchar(32) NULL,
    CREATEDDATE timestamptz NULL,
    CREDITBALANCE number NULL,
    CREDITMEMOTEMPLATEID varchar(32) NULL,
    CRMID varchar(100) NULL,
    CURRENCY varchar(16777216) NULL,
    CURRENCYCODE varchar(16777216) NULL,
    CUSTOMERSERVICEREPNAME varchar(50) NULL,
    DEBITMEMOTEMPLATEID varchar(32) NULL,
    DEFAULTPAYMENTMETHODID varchar(32) NULL,
    DELETED boolean NULL,
    AccountID CHAR(18) NOT NULL,
    INVOICEDELIVERYPREFSEMAIL boolean NULL,
    INVOICEDELIVERYPREFSPRINT boolean NULL,
    INVOICETEMPLATEID varchar(32) NULL,
    LASTINVOICEDATE date NULL,
    MRR number NULL,
    NAME varchar(255) NULL,
    NOTES varchar(16777216) NULL,
    PARENTID varchar(32) NULL,
    PAYMENTGATEWAY varchar(40) NULL,
    PAYMENTTERM varchar(100) NULL,
    PURCHASEORDERNUMBER varchar(100) NULL,
    SALESREPNAME varchar(50) NULL,
    SEQUENCESETID varchar(32) NULL,
    SOLDTOID varchar(32) NULL,
    STATUS varchar(16777216) NULL,
    TAXCOMPANYCODE varchar(50) NULL,
    TAXEXEMPTCERTIFICATEID varchar(32) NULL,
    TAXEXEMPTCERTIFICATETYPE varchar(32) NULL,
    TAXEXEMPTDESCRIPTION varchar(16777216) NULL,
    TAXEXEMPTEFFECTIVEDATE date NULL,
    TAXEXEMPTENTITYUSECODE varchar(32) NULL,
    TAXEXEMPTEXPIRATIONDATE date NULL,
    TAXEXEMPTISSUINGJURISDICTION varchar(32) NULL,
    TAXEXEMPTSTATUS varchar(32) NULL,
    TOTALDEBITMEMOBALANCE number NULL,
    TOTALINVOICEBALANCE number NULL,
    UNAPPLIEDBALANCE number NULL,
    UNAPPLIEDCREDITMEMOAMOUNT number NULL,
    UPDATEDBYID varchar(32) NULL,
    UPDATEDDATE timestamptz NULL,
    VATID varchar(255) NULL
    );

ALTER TABLE STAGING.STG_MDM_ORGANISATION ADD CONSTRAINT PK_STG_MDM_ORGANISATION
    PRIMARY KEY(SEQ_KEY);

USE DBTVAULT_DEV;
USE SCHEMA VAULT;

/****** Object:  Table VAULT.RV_ORGANISATION_HUB   *****/
CREATE OR REPLACE TABLE VAULT.RV_ORGANISATION_HUB (
    ORGANISATION_HSH VARCHAR(32) NOT NULL,
    LOAD_DTS TIMESTAMP_NTZ NOT NULL,
    RECORD_SOURCE VARCHAR(100) NOT NULL,
    AccountID CHAR(18) NOT NULL,
    BKCC VARCHAR(10) NOT NULL
    );

ALTER TABLE VAULT.RV_ORGANISATION_HUB ADD CONSTRAINT PK_RV_ORGANISATION_HUB
    PRIMARY KEY(ORGANISATION_HSH);

/****** Object:  Table VAULT.RV_ORGANISATION_MDM_SAT   *****/
CREATE OR REPLACE TABLE VAULT.RV_ORGANISATION_MDM_SAT (
    ORGANISATION_HSH VARCHAR(32) NOT NULL,
    LOAD_DTS TIMESTAMP_NTZ NOT NULL,
    BKCC VARCHAR(10) NOT NULL,
    ORGANISATION_HSH_DIFF VARCHAR(32) NOT NULL,
    RECORD_SOURCE VARCHAR(100) NOT NULL,
    ACCOUNTNUMBER varchar(70) NULL,
    ADDITIONALEMAILADDRESSES varchar(1200) NULL,
    ALLOWINVOICEEDIT boolean NULL,
    AUTOPAY boolean NULL,
    BALANCE number NULL,
    BATCH varchar(20) NULL,
    BCDSETTINGOPTION varchar(16777216) NULL,
    BILLCYCLEDAY number NULL,
    BILLTOID varchar(32) NULL,
    COMMUNICATIONPROFILEID varchar(32) NULL,
    CREATEDBYID varchar(32) NULL,
    CREATEDDATE timestamptz NULL,
    CREDITBALANCE number NULL,
    CREDITMEMOTEMPLATEID varchar(32) NULL,
    CRMID varchar(100) NULL,
    CURRENCY varchar(16777216) NULL,
    CURRENCYCODE varchar(16777216) NULL,
    CUSTOMERSERVICEREPNAME varchar(50) NULL,
    DEBITMEMOTEMPLATEID varchar(32) NULL,
    DEFAULTPAYMENTMETHODID varchar(32) NULL,
    DELETED boolean NULL,
    AccountID CHAR(18) NOT NULL,
    INVOICEDELIVERYPREFSEMAIL boolean NULL,
    INVOICEDELIVERYPREFSPRINT boolean NULL,
    INVOICETEMPLATEID varchar(32) NULL,
    LASTINVOICEDATE date NULL,
    MRR number NULL,
    NAME varchar(255) NULL,
    NOTES varchar(16777216) NULL,
    PARENTID varchar(32) NULL,
    PAYMENTGATEWAY varchar(40) NULL,
    PAYMENTTERM varchar(100) NULL,
    PURCHASEORDERNUMBER varchar(100) NULL,
    SALESREPNAME varchar(50) NULL,
    SEQUENCESETID varchar(32) NULL,
    SOLDTOID varchar(32) NULL,
    STATUS varchar(16777216) NULL,
    TAXCOMPANYCODE varchar(50) NULL,
    TAXEXEMPTCERTIFICATEID varchar(32) NULL,
    TAXEXEMPTCERTIFICATETYPE varchar(32) NULL,
    TAXEXEMPTDESCRIPTION varchar(16777216) NULL,
    TAXEXEMPTEFFECTIVEDATE date NULL,
    TAXEXEMPTENTITYUSECODE varchar(32) NULL,
    TAXEXEMPTEXPIRATIONDATE date NULL,
    TAXEXEMPTISSUINGJURISDICTION varchar(32) NULL,
    TAXEXEMPTSTATUS varchar(32) NULL,
    TOTALDEBITMEMOBALANCE number NULL,
    TOTALINVOICEBALANCE number NULL,
    UNAPPLIEDBALANCE number NULL,
    UNAPPLIEDCREDITMEMOAMOUNT number NULL,
    UPDATEDBYID varchar(32) NULL,
    UPDATEDDATE timestamptz NULL,
    VATID varchar(255) NULL
    );

ALTER TABLE VAULT.RV_ORGANISATION_MDM_SAT ADD CONSTRAINT PK_RV_ORGANISATION_MDM_SAT
    PRIMARY KEY(ORGANISATION_HSH,LOAD_DTS);

ALTER TABLE VAULT.RV_ORGANISATION_MDM_SAT ADD CONSTRAINT FK_RV_ORGANISATION_MDM_SAT_RV_ORGANISATION_HUB
    FOREIGN KEY (ORGANISATION_HSH) REFERENCES RV_ORGANISATION_HUB(ORGANISATION_HSH);

