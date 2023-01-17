WITH t(code, description) AS (
    SELECT 1, 'AAA'
    UNION
    SELECT 2, 'AAA'
    UNION
    SELECT 3, NULL
    UNION
    SELECT 4, 'BBB'
)

-- 2
-- SELECT COUNT(*) AS test_count
-- FROM t
-- WHERE description = 'AAA'

-- 2
-- SELECT COUNT(description) AS test_count
-- FROM t
-- WHERE description = 'AAA'

-- 3
-- SELECT COUNT(description) AS test_count
-- FROM t

-- 3
-- SELECT COUNT(description = 'AAA') AS test_count
-- FROM t

-- 3
-- SELECT COUNT(description != 'AAA') AS test_count
-- FROM t

-- 4
-- SELECT COUNT(description IS NULL) AS test_count
-- FROM t

-- 4
-- SELECT COUNT(description IS NOT NULL) AS test_count
-- FROM t
;
