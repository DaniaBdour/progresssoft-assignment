SET LINESIZE 200
SET PAGESIZE 50
COLUMN "Employee ID"   FORMAT 99
COLUMN "Employee Name" FORMAT A20
COLUMN "Hire Date"     FORMAT A12
COLUMN "Salary"        FORMAT 99999
COLUMN "Job Title"     FORMAT A20
COLUMN "Department"    FORMAT A12
COLUMN "Manager"       FORMAT A20
COLUMN "Gender"        FORMAT A8
COLUMN "University"    FORMAT A35

SELECT
  e.ID                                    AS "Employee ID",
  e.FIRST_NAME || ' ' || e.LAST_NAME     AS "Employee Name",
  e.HIRE_DATE                             AS "Hire Date",
  e.SALARY                                AS "Salary",
  e.JOB_TITLE                             AS "Job Title",
  d.Name                                  AS "Department",
  m.FIRST_NAME || ' ' || m.LAST_NAME     AS "Manager",
  g.Name                                  AS "Gender",
  u.Name                                  AS "University"
FROM      MyEmployee  e
LEFT JOIN MyDepartment d  ON e.DEPT_ID       = d.Dept_ID
LEFT JOIN MyEmployee   m  ON e.MANAGER_ID    = m.ID
LEFT JOIN Gender       g  ON e.Gender_ID     = g.Gender_ID
LEFT JOIN University   u  ON e.University_ID = u.ID
ORDER BY e.ID;
