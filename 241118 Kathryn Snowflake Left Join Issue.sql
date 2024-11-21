--6,098,840 (integrasentdate) 6,092,673 (createdate)
SELECT 
      -- pc.PAY_CLAIM_ID
      -- ,p.CLAIM CLAIM_SRC_VER_ID
      NULL AS PROVIDER_CLAIM_NUM
      -- ,COALESCE(c.H22_MEDICAIDREFNO, p.ICN) AS PAYER_CLAIM_NUM
      ,c.CLAIM AS PAYER_LOB_ID
      ,off.DORIID AS PROV_FAC_ID
      ,c.PATIENT AS mbr_id
      ,COALESCE(pa.FIRSTNAME, c.H2_PATIENTFIRSTNAME) AS MBR_FIRST_NAME
      ,COALESCE(pa.LASTNAME, c.H2_PATIENTLASTNAME) AS MBR_LAST_NAME
      ,COALESCE(pi.policynumber, c.H1A_INSURANCEID) AS MBR_INSURANCE_NUM
      ,c.INTEGRASENTDATE AS SENT_TO_PAYER_TS
      -- ,COALESCE(c.DATEOFSERVICE, H24A_DOSFROM) AS CLAIM_DOS
      ,c.DATEOFSERVICE AS CLAIM_DOS
      ,'SEN' AS CLAIM_STATUS_CODE
      ,'' AS CLAIM_PROC_STATUS
      ,CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS EFF_START_TS
      ,NULL AS EFF_END_TS
      ,CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS CREATED_TS
      ,'MIGRATION' AS CREATED_BY
      ,'DV001' AS APP_VER
      ,CONCAT(COALESCE(pa.FIRSTNAME, c.H2_PATIENTFIRSTNAME) || ' ' || COALESCE(pa.LASTNAME, c.H2_PATIENTLASTNAME)) AS MBR_FULL_NAME
      ,CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS MODIFIED_TS
      ,'MIGRATION' AS MODIFIED_BY
      -- ,p.CLAIMNUMBER AS INT_CLAIM_NUM
      ,pa.DOB AS MBR_DOB
      ,org.DORIID AS PROV_ORG_ID
FROM claim AS c
-- LEFT JOIN kmintram_sandbox_db.marts.pay_claim AS pc
--     ON pc.CLAIM_SRC_ID = c.CLAIM
LEFT JOIN patientinsurance AS pi
    ON pi.PATIENTINSURANCE = c.PATIENTINSURANCE
LEFT JOIN patient AS pa
    ON pa.PATIENT = c.PATIENT
LEFT JOIN office AS off
    ON off.OFFICE = c.OFFICE
    AND off.ACTIVE = true
LEFT JOIN organization AS org
    ON org.organization = c.organization
WHERE c.INTEGRASENTDATE IS NOT NULL
AND c.CREATEDATE >= '2021-01-01'
AND PROV_FAC_ID IS NULL;
-- AND PAY_CLAIM_ID IS NULL;


SELECT count(*)
from claim c
left join kmintram_sandbox_db.marts.pay_claim AS pc
    ON pc.CLAIM_SRC_ID = c.CLAIM
WHERE c.INTEGRASENTDATE IS NOT NULL
AND c.CREATEDATE >= '2021-01-01'
AND PAY_CLAIM_ID IS NULL;

--5,804,728
ALTER SESSION SET USE_CACHED_RESULT=FALSE;
WITH payments AS (
    SELECT CLAIM
          ,CLAIMNUMBER
          ,ICN
    FROM payment
    WHERE CLAIM IS NOT NULL
    -- AND ICN IS NOT NULL
    QUALIFY ROW_NUMBER() OVER (PARTITION BY CLAIM ORDER BY CREATEDATE DESC) = 1
)
SELECT 
       c.CLAIM
      -- ,COALESCE(c.H22_MEDICAIDREFNO, p.ICN) AS PAYER_CLAIM_NUM
      ,p.CLAIM AS pc
FROM claim c
LEFT join payments p
    on c.claim = p.claim
-- WHERE c.INTEGRASENTDATE IS NOT NULL
-- AND c.CREATEDATE >= '2021-01-01'
-- and p.claim is null;
where p.claim is null
and c.createdate >= '2021-01-01';

select c.claim, c.originalclaim, p.claim
from claim c
left join payment p
    on p.claim = c.claim
where c.originalclaim <> c.claim;

select claim 
from claim
where claim not in (select distinct claim from payment);

select *
from payment
where claim is null;

select distinct claim from claim where createdate >= '2021-01-01'
except
select distinct claim from payment;

select claim
from claim
where claim is null;

select *
from payment
where claim is null;

--6,404,130
select distinct claim
from payment
where claim not in (


-- target 6,098,840 -- difference 409,950
select claim
from claim
where integrasentdate is not null
and integrasentdate >= '2021-01-01');

-- 409,951
select distinct claim
from payment
where exists (select 1 claim
              from claim 
              where integrasentdate is not null
              and integrasentdate >= '2021-01-01'
              and payment.claim = claim.claim);


select *
from payment
where claim = 7907625;

select *
from claim 
where claim = 7907625;
                  

--6,092,673 -- 5,989,166
WITH payments AS (
    SELECT CLAIM 
          ,CREATEDATE
          -- ,CLAIMNUMBER
          -- ,ICN
    FROM payment
    -- WHERE CLAIM IS NOT NULL
    -- -- AND ICN IS NOT NULL
    -- QUALIFY ROW_NUMBER() OVER (PARTITION BY CLAIM ORDER BY CREATEDATE DESC) = 1
)
SELECT 
   c.CLAIM
  -- ,COALESCE(c.H22_MEDICAIDREFNO, p.ICN) AS PAYER_CLAIM_NUM
  ,p.CLAIM AS pc
FROM claim c
LEFT JOIN payments AS p
ON c.claim = p.claim
WHERE c.INTEGRASENTDATE IS NOT NULL
AND c.CREATEDATE >= '2021-01-01'
AND p.CLAIM IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY p.CLAIM ORDER BY p.CREATEDATE DESC) = 1;



select claim
from claim 
where and INTEGRASENTDATE IS NOT NULL
AND CREATEDATE >= '2021-01-01'
AND  claim not exists (select 1 claim from payment)