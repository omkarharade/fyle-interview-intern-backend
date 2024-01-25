-- Write query to find the number of grade A's given by the teacher who has graded the most assignments

WITH RankedTeachers AS (
    SELECT
        teacher_id,
        RANK() OVER (ORDER BY COUNT(grade) DESC) AS teacher_rank
    FROM
        assignments
    WHERE
        grade IS NOT NULL
    GROUP BY
        teacher_id
)

SELECT
    COUNT(*) AS a_gradings
FROM
    assignments
WHERE
    grade = 'A'
    AND teacher_id = (SELECT teacher_id FROM RankedTeachers WHERE teacher_rank = 1);

