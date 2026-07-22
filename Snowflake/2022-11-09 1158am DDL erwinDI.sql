USE DATABASE DBTVAULT_DEV;

DROP SCHEMA BMC_ZUORA;

CREATE SCHEMA BMC_ZUORA;

CREATE SCHEMA BMC_ERWIN;



-- Generated

USE 01_source;
/***** Script Date: Wed Nov 09 2022 15:20:31 GMT+0000 (UTC) ******/
/****** Object:  Table baseline_vault.stg_01_source_employee_l2   *****/
CREATE TABLE baseline_vault.stg_01_source_employee_l2 (
    sqn bigint identity NOT NULL,
    employee_hk binary NOT NULL,
    employee_hdiff binary NOT NULL,
    ldts timestamp NOT NULL,
    rsrc varchar(255) NOT NULL,
    nationalidnumber VARCHAR(50) NOT NULL,
    N_NATIONKEY NUMBER NULL,
    C_NAME VARCHAR(25) NULL,
    C_ADDRESS VARCHAR(40) NULL,
    C_PHONE VARCHAR(15) NULL,
    C_ACCTBAL NUMBER NULL,
    C_MKTSEGMENT VARCHAR(10) NULL,
    C_COMMENT VARCHAR(117) NULL
    );

ALTER TABLE baseline_vault.stg_01_source_employee_l2 ADD CONSTRAINT PK_stg_01_source_employee_l2
    PRIMARY KEY(sqn);

/****** Object:  Table baseline_vault.rv_employee_h   *****/
CREATE TABLE baseline_vault.rv_employee_h (
    employee_hk binary NOT NULL,
    ldts timestamp NOT NULL,
    rsrc varchar(255) NOT NULL,
    nationalidnumber VARCHAR(50) NOT NULL
    );

ALTER TABLE baseline_vault.rv_employee_h ADD CONSTRAINT PK_rv_employee_h
    PRIMARY KEY(employee_hk);

/****** Object:  Table baseline_vault.rv_employee_hsat   *****/
CREATE TABLE baseline_vault.rv_employee_hsat (
    employee_hk binary NOT NULL,
    ldts timestamp NOT NULL,
    employee_hdiff binary NOT NULL,
    rsrc varchar(255) NOT NULL,
    N_NATIONKEY NUMBER NULL,
    C_NAME VARCHAR(25) NULL,
    C_ADDRESS VARCHAR(40) NULL,
    C_PHONE VARCHAR(15) NULL,
    C_ACCTBAL NUMBER NULL,
    C_MKTSEGMENT VARCHAR(10) NULL,
    C_COMMENT VARCHAR(117) NULL
    );

ALTER TABLE baseline_vault.rv_employee_hsat ADD CONSTRAINT PK_rv_employee_hsat
    PRIMARY KEY(employee_hk,ldts);

ALTER TABLE baseline_vault.rv_employee_hsat ADD CONSTRAINT FK_rv_employee_hsat_rv_employee_h
    FOREIGN KEY (employee_hk) REFERENCES baseline_vault.rv_employee_h(employee_hk);



-- Reviewed

CREATE OR REPLACE TABLE DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2 (
    sqn BIGINT IDENTITY NOT NULL,
    employee_hk BINARY(16) NOT NULL,
    employee_hdiff BINARY(16) NOT NULL,
    ldts TIMESTAMP NOT NULL,
    rsrc VARCHAR(255) NOT NULL,
    nationalidnumber VARCHAR(50) NOT NULL,
    N_NATIONKEY NUMBER NULL,
    C_NAME VARCHAR(25) NULL,
    C_ADDRESS VARCHAR(40) NULL,
    C_PHONE VARCHAR(15) NULL,
    C_ACCTBAL NUMBER NULL,
    C_MKTSEGMENT VARCHAR(10) NULL,
    C_COMMENT VARCHAR(117) NULL
    );

ALTER TABLE DBTVAULT_DEV.BMC_ERWIN.stg_01_source_employee_l2 ADD CONSTRAINT PK_stg_01_source_employee_l2
    PRIMARY KEY(sqn);

/****** Object:  Table baseline_vault.rv_employee_h   *****/
CREATE OR REPLACE TABLE DBTVAULT_DEV.BMC_ERWIN.rv_employee_h (
    employee_hk BINARY(16) NOT NULL,
    ldts timestamp NOT NULL,
    rsrc varchar(255) NOT NULL,
    nationalidnumber VARCHAR(50) NOT NULL
    );

ALTER TABLE DBTVAULT_DEV.BMC_ERWIN.rv_employee_h ADD CONSTRAINT PK_rv_employee_h
    PRIMARY KEY(employee_hk);

/****** Object:  Table baseline_vault.rv_employee_hsat   *****/
CREATE OR REPLACE TABLE DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat (
    employee_hk BINARY(16) NOT NULL,
    ldts TIMESTAMP NOT NULL,
    employee_hdiff BINARY(16) NOT NULL,
    rsrc VARCHAR(255) NOT NULL,
    N_NATIONKEY NUMBER NULL,
    C_NAME VARCHAR(25) NULL,
    C_ADDRESS VARCHAR(40) NULL,
    C_PHONE VARCHAR(15) NULL,
    C_ACCTBAL NUMBER NULL,
    C_MKTSEGMENT VARCHAR(10) NULL,
    C_COMMENT VARCHAR(117) NULL
    );

ALTER TABLE DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat ADD CONSTRAINT PK_rv_employee_hsat
    PRIMARY KEY(employee_hk,ldts);

ALTER TABLE DBTVAULT_DEV.BMC_ERWIN.rv_employee_hsat ADD CONSTRAINT FK_rv_employee_hsat_rv_employee_h
    FOREIGN KEY (employee_hk) REFERENCES DBTVAULT_DEV.BMC_ERWIN.rv_employee_h(employee_hk);
