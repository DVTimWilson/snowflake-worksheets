--admin orders query
  WITH date_ranges AS (
SELECT
    18 AS nth_weeks_ago,
    DATEADD(WEEK, -18, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -17, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
SELECT
    17 AS nth_weeks_ago,
    DATEADD(WEEK, -17, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -16, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
SELECT
    16 AS nth_weeks_ago,
    DATEADD(WEEK, -16, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -15, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
  SELECT
    15 AS nth_weeks_ago,
    DATEADD(WEEK, -15, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -14, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    14 AS nth_weeks_ago,
    DATEADD(WEEK, -14, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -13, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    13 AS nth_weeks_ago,
    DATEADD(WEEK, -13, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -12, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    12 AS nth_weeks_ago,
    DATEADD(WEEK, -12, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -11, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    11 AS nth_weeks_ago,
    DATEADD(WEEK, -11, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -10, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    10 AS nth_weeks_ago,
    DATEADD(WEEK, -10, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -9, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
SELECT
    9 AS nth_weeks_ago,
    DATEADD(WEEK, -9, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -8, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
 SELECT
    8 AS nth_weeks_ago,
    DATEADD(WEEK, -8, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -7, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
 SELECT
    7 AS nth_weeks_ago,
    DATEADD(WEEK, -7, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -6, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
 SELECT
    6 AS nth_weeks_ago,
    DATEADD(WEEK, -6, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -5, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL 
 SELECT
    5 AS nth_weeks_ago,
    DATEADD(WEEK, -5, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -4, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
  SELECT
    4 AS nth_weeks_ago,
    DATEADD(WEEK, -4, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -3, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
  SELECT
    3 AS nth_weeks_ago,
    DATEADD(WEEK, -3, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -2, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
  SELECT
    2 AS nth_weeks_ago,
    DATEADD(WEEK, -2, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATEADD(WEEK, -1, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_end
  UNION ALL
  SELECT
    1 AS nth_weeks_ago,
    DATEADD(WEEK, -1, DATE_TRUNC('WEEK', CURRENT_DATE)) AS week_start,
    DATE_TRUNC('WEEK', CURRENT_DATE) AS week_end
  UNION ALL
  SELECT
    0 AS nth_weeks_ago,
    DATE_TRUNC('WEEK', CURRENT_DATE) AS week_start,
    CURRENT_DATE AS week_end
),
orders_with_rank AS (
  SELECT
    os.*,
    dr.*,
    ROW_NUMBER() OVER (PARTITION BY os.ORDER_ID, dr.nth_weeks_ago ORDER BY os.CREATED_TS DESC) AS rn
  FROM
    PRISM_CLEAR_ORDER.ORDER_STATUS_HIST os
    LEFT JOIN PRISM_CLEAR_ORDER.ORDERS o ON o.ORDER_ID =os.ORDER_ID 
  CROSS JOIN
    date_ranges dr
  WHERE
    os.CREATED_TS < dr.week_end
    AND CONVERT_TIMEZONE ('America/New_York',o.CREATED_TS) >= '2022-08-01'
    AND o.ORDER_SYSTEM_TYPE != 'RECURRING'
),
filtered_orders_with_rank AS (
  SELECT
    *
  FROM
    orders_with_rank
  WHERE
    rn = 1
    AND ORDER_STATUS_CODE NOT IN ('FUTURE_DOS', 'CANCELLED', 'SHIPPED', 'DELIVERED','STAGED')
)
SELECT
  filtered_orders_with_rank.*, 
  CONVERT_TIMEZONE ('America/New_York',ORDERS.CREATED_TS) "ORDER CREATED TS", 
  PAYER_FAMS.PAYER_FAM_NAME "HEALTH PLAN",
  PAYER_PLANS.PAYER_PLAN_NAME "PAYER PLAN",
  PAYER_ACCTS.PAYER_ACCT_NAME "PAYER_ACCOUNT",
  PAYER_LOBS.PAYER_LOB_NAME "PAYER_LOB",
  ORDERS.ORDER_NUM,
  ORDERS.ORDER_NUM "ORDER NAME",
  PROVIDERS.DBANAME "PROVIDER",
ORDERS.ORDER_SYSTEM_TYPE
FROM filtered_orders_with_rank
INNER JOIN PRISM_CLEAR_ORDER.ORDERS  on ORDERS.ORDER_ID = filtered_orders_with_rank.ORDER_ID
INNER JOIN PRISM_CLEAR_MEMBER.MBRS MBRS ON ORDERS.MBR_ID = MBRS.MBR_ID
  	-- FIND PAYER LOB
INNER JOIN PRISM_CLEAR_PAYER.PAYER_LOBS PAYER_LOBS ON PAYER_LOBS.PAYER_LOB_ID = MBRS.PAYER_LOB_ID
INNER JOIN PRISM_CLEAR_PAYER.PAYER_ACCTS PAYER_ACCTS ON PAYER_LOBS.PAYER_ACCT_ID = PAYER_ACCTS.PAYER_ACCT_ID
INNER JOIN PRISM_CLEAR_PAYER.PAYER_PLANS PAYER_PLANS ON PAYER_ACCTS.PAYER_PLAN_ID = PAYER_PLANS.PAYER_PLAN_ID
INNER JOIN PRISM_CLEAR_PAYER.PAYER_FAMS PAYER_FAMS Using (PAYER_FAM_ID) 
LEFT OUTER JOIN 
  					     (
  					       SELECT OP.ORDER_PROVIDER_ID
  						  		 ,O.DBANAME
  						         ,O.LEGALNAME
  						         ,F.STORENAME
  						         ,OP.IS_CURRENT
  						         ,OP.PROVIDER_ORG_ID
  							FROM PRISM_CLEAR_ORDER.ORDER_PROVIDERS OP
  							LEFT JOIN DORI.FACILITY F ON OP.PROVIDER_FAC_ID = F.FACILITYID
  							LEFT JOIN DORI.ORGANIZATION O ON OP.PROVIDER_ORG_ID = O.ORGANIZATIONID
  					      ) AS PROVIDERS ON PROVIDERS.ORDER_PROVIDER_ID = filtered_orders_with_rank.ORDER_PROVIDER_ID AND PROVIDERS.PROVIDER_ORG_ID > 0 --AND PROVIDERS.IS_CURRENT = TRUE 
WHERE PAYER_PLANS.PAYER_PLAN_NAME NOT LIKE '%Test%' 
AND PAYER_PLANS.PAYER_PLAN_NAME NOT LIKE '%Leila%' AND PAYER_PLANS.PAYER_PLAN_NAME NOT LIKE '%Jasen%' AND PAYER_PLANS.PAYER_PLAN_NAME NOT LIKE '%Milford%' AND PAYER_PLANS.PAYER_PLAN_NAME NOT LIKE '%Gustave%' 
AND ORDER_STATUS_CODE = 'IN_PROGRESS'
 --ORDER BY ORDERS."nth_weeks_ago" DESC