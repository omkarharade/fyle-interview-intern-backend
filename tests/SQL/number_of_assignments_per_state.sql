-- Write query to get number of assignments for each state
SELECT
    'DRAFT' AS state,
    COUNT(CASE WHEN state = 'DRAFT' THEN 1 ELSE NULL END) AS count
FROM
    assignments

UNION ALL

SELECT
    'GRADED' AS state,
    COUNT(CASE WHEN state = 'GRADED' THEN 1 ELSE NULL END) AS count
FROM
    assignments

UNION ALL

SELECT
    'SUBMITTED' AS state,
    COUNT(CASE WHEN state = 'SUBMITTED' THEN 1 ELSE NULL END) AS count
FROM
    assignments;
