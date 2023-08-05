-- NULL
SELECT NULL AS testing
;

-- AND operations are false as soon as any operand is false
-- NULL
SELECT NULL AND true AS testing
;

-- NULL
SELECT NULL AND 1 = 1 AS testing
;

-- false
SELECT NULL AND false AS testing
;

-- false
SELECT NULL AND 1 = 0 AS testing
;

-- OR operations are true as soon as any operand is true
-- true
SELECT NULL OR true AS testing
;

-- true
SELECT NULL OR 1 = 1 AS testing
;

-- NULL
SELECT NULL OR false AS testing
;

-- NULL
SELECT NULL OR 1 = 0 AS testing
;

WITH sampledata (id, status) AS (
    SELECT 1, 'A'
    UNION ALL
    SELECT 2, 'B'
    UNION ALL
    SELECT 3, NULL
    UNION ALL
    SELECT 4, 'D'
)

SELECT *
FROM sampledata

-- unknown OR anything/nothing is anything/nothing
-- 1 A
--WHERE status IN (NULL, 'A')
-- 1 A
--WHERE status = NULL OR status = 'A'
-- no results
--WHERE status IN (NULL, 'C')

-- unknown AND anything/nothing is still unknown
-- no results
--WHERE status NOT IN (NULL, 'A')
-- no results
--WHERE NOT (status = NULL) AND NOT (status = 'A')
-- no results
--WHERE status NOT IN (NULL, 'C')
;

-- NULL
SELECT NULL / 0 AS testing
;

-- NULL
SELECT 0 / NULL AS testing
;