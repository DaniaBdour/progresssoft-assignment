SELECT
  JOB_TITLE                AS "Job Title",
  COUNT(*)                 AS "Employee Count",
  SUM(SALARY)              AS "Total Monthly Salary"
FROM MyEmployee
WHERE UPPER(JOB_TITLE) NOT LIKE '%SALES%'
GROUP BY JOB_TITLE
HAVING SUM(SALARY) > 2500
ORDER BY SUM(SALARY) DESC;
