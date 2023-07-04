ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT CI.CLAIM
	,CI.CLAIMITEM
    ,CI.H24F_Charge
    ,pay.TotalPaid
    ,pay.TotalAdj
	,(ROUND(IFNULL(CI.H24F_Charge, 0), 2) - ROUND(IFNULL(pay.TotalPaid, 0), 2) - ROUND(IFNULL(pay.TotalAdj, 0), 2)) OPEN_AR
FROM "PROD_ANALYTICS_DB"."QUE"."CLAIMITEM" AS CI
LEFT OUTER JOIN (
	SELECT PL.ClaimItem
		,P.Claim
		,IFNULL(SUM(CASE 
					WHEN EB.Reconcile IS NOT NULL
						AND PL.IncludeLine = 1
						THEN IFNULL(PL.CorrPay, PL.Paid)
					ELSE 0
					END), 0) AS TotalPaid
		,IFNULL(SUM((
					CASE 
						WHEN EB.Reconcile IS NOT NULL
							AND PL.IncludeLine = 1
							THEN IFNULL(PL.CorrAdj, 0) + IFNULL(PL.Deductible, 0) + IFNULL(PL.CoIns, 0) + IFNULL(PL.CoPay, 0) + IFNULL(PL.PatientRespAdj, 0)
						ELSE 0
						END
					) + IFNULL((
						CASE 
							WHEN PL.IncludeLine = 1
								THEN PL.Adj
							ELSE 0
							END
						), 0)), 0) AS TotalAdj
	FROM "PROD_ANALYTICS_DB"."QUE"."PAYMENTLINEITEM" AS PL
	INNER JOIN "PROD_ANALYTICS_DB"."QUE"."PAYMENT" AS P
        ON P.Payment = PL.Payment
	--Made the left join to get correct adjustments. PY+YI 
	LEFT OUTER JOIN "PROD_ANALYTICS_DB"."QUE"."EOB" AS EB
        ON P.EOB = EB.EOB
	GROUP BY PL.ClaimItem, P.Claim
	) AS pay
    ON pay.ClaimItem = CI.ClaimItem
	    AND pay.Claim = CI.Claim
;


ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT CI.CLAIM
	,CI.CLAIMITEM
	,(ROUND(IFNULL(CI.H24F_Charge, 0), 2) - ROUND(IFNULL(pay.TotalPaid, 0), 2) - ROUND(IFNULL(pay.TotalAdj, 0), 2)) AS OPEN_AR
FROM "PROD_ANALYTICS_DB"."QUE"."CLAIMITEM" AS CI
LEFT OUTER JOIN (
	SELECT PL.ClaimItem
		,MAX(P.Claim) AS Claim
		,IFNULL(SUM(CASE 
					WHEN EB.Reconcile IS NOT NULL
						AND PL.IncludeLine = 1
						THEN IFNULL(PL.CorrPay, PL.Paid)
					ELSE 0
					END), 0) AS TotalPaid
		,IFNULL(SUM((
					CASE 
						WHEN EB.Reconcile IS NOT NULL
							AND PL.IncludeLine = 1
							THEN IFNULL(PL.CorrAdj, 0) + IFNULL(PL.Deductible, 0) + IFNULL(PL.CoIns, 0) + IFNULL(PL.CoPay, 0) + IFNULL(PL.PatientRespAdj, 0)
						ELSE 0
						END
					) + IFNULL((
						CASE 
							WHEN PL.IncludeLine = 1
								THEN PL.Adj
							ELSE 0
							END
						), 0)), 0) AS TotalAdj
	FROM "PROD_ANALYTICS_DB"."QUE"."PAYMENTLINEITEM" AS PL
	INNER JOIN "PROD_ANALYTICS_DB"."QUE"."PAYMENT" AS P
        ON P.Payment = PL.Payment
	--Made the left join to get correct adjustments. PY+YI 
	LEFT OUTER JOIN "PROD_ANALYTICS_DB"."QUE"."EOB" AS EB
        ON P.EOB = EB.EOB
	GROUP BY PL.ClaimItem
	) AS pay
    ON pay.ClaimItem = CI.ClaimItem
	    AND pay.Claim = CI.Claim
;


SELECT *
FROM PROD_ANALYTICS_DB.QUE.MASSADJDETAILREPORT AS m
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on m.CLAIMITEM = ci.CLAIMITEM
WHERE m.CLAIM = 9191997
;

SELECT *
FROM PROD_ANALYTICS_DB.QUE.PAYMENTLINEITEM AS p
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on p.CLAIMITEM = ci.CLAIMITEM
WHERE CLAIM = 9191997
;

SELECT *
FROM PROD_ANALYTICS_DB.QUE.MASSADJDETAILREPORT AS m
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on m.CLAIMITEM = ci.CLAIMITEM
WHERE m.CLAIM = 9366501
;

SELECT *
FROM PROD_ANALYTICS_DB.QUE.PAYMENTLINEITEM AS p
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on p.CLAIMITEM = ci.CLAIMITEM
WHERE CLAIM = 9366501
;

SELECT *
FROM PROD_ANALYTICS_DB.QUE.MASSADJDETAILREPORT AS m
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on m.CLAIMITEM = ci.CLAIMITEM
WHERE m.CLAIM = 10047784
;

SELECT *
FROM PROD_ANALYTICS_DB.QUE.PAYMENTLINEITEM AS p
INNER JOIN PROD_ANALYTICS_DB.QUE.CLAIMITEM AS ci
on p.CLAIMITEM = ci.CLAIMITEM
WHERE CLAIM = 10047784
;