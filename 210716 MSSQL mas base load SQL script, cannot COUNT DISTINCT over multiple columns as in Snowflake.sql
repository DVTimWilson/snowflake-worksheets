IF OBJECT_ID('TEST', 'U') IS NOT NULL
	DROP TABLE TEST

CREATE TABLE TEST (CUSTOMER_ID integer, CUSTOMER_NAME varchar(10), CUSTOMER_PHONE varchar(5), LOAD_DATE date, SOURCE varchar(5));

INSERT INTO TEST VALUES (1001, 'Alice', '1214', '1993-01-01', '*');
INSERT INTO TEST VALUES (1001, 'Alice', '1224', '1993-01-01', '*');
INSERT INTO TEST VALUES (1001, 'Alice', '1234', '1993-01-01', '*');
INSERT INTO TEST VALUES (1002, 'Bart',  '1215', '1993-01-01', '*');
INSERT INTO TEST VALUES (1002, 'Bart',  '1225', '1993-01-01', '*');
INSERT INTO TEST VALUES (1003, 'Chad',  '1216', '1993-01-01', '*');

SELECT s.*, cd.*
FROM TEST s
CROSS APPLY
(
SELECT CUSTOMER_ID, COUNT(*) AS ma_key_count
FROM (SELECT DISTINCT CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_PHONE FROM TEST) t
WHERE t. CUSTOMER_ID = s.CUSTOMER_ID
GROUP BY CUSTOMER_ID
) cd




SELECT DISTINCT CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_PHONE FROM TEST
