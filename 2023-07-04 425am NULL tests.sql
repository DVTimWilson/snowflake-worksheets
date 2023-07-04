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
--WHERE status IN (NULL, 'A')
--WHERE status = NULL OR status = 'A'
--WHERE status IN (NULL, 'C')

-- unknown AND anything/nothing is still unknown
--WHERE status NOT IN (NULL, 'A')
--WHERE NOT (status = NULL) AND NOT (status = 'A')
--WHERE status NOT IN (NULL, 'C')
;