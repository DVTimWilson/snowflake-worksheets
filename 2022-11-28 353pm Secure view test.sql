SELECT 
	ID,
	FIRST_NAME,
	LAST_NAME
FROM SANDBOX.TIM_WILSON.JS_CUSTOMERS
;

CREATE OR REPLACE VIEW SANDBOX.TIM_WILSON.JS_CUSTOMERS_VIEW AS (
    SELECT 
        ID,
        FIRST_NAME,
        LAST_NAME
    FROM SANDBOX.TIM_WILSON.JS_CUSTOMERS
)
;


ALTER VIEW SANDBOX.TIM_WILSON.JS_CUSTOMERS_VIEW
SET SECURE
;

SELECT *
FROM SANDBOX.TIM_WILSON.JS_CUSTOMERS_VIEW
;


USE DATABASE DBTVAULT_DEV
;

SELECT *
FROM SANDBOX.TIM_WILSON.JS_CUSTOMERS_VIEW
;

CREATE OR REPLACE VIEW DBTVAULT_DEV.BMC_ZUORA.JS_CUSTOMERS_VIEW AS (
    SELECT 
        ID,
        FIRST_NAME,
        LAST_NAME
    FROM SANDBOX.TIM_WILSON.JS_CUSTOMERS
)
;

