CREATE OR REPLACE FUNCTION F_HR_QUERY
RETURN SYS_REFCURSOR
IS
  v_cursor      SYS_REFCURSOR;
  v_scott_date  DATE;
BEGIN
  SELECT HIRE_DATE
  INTO   v_scott_date
  FROM   MyEmployee
  WHERE  UPPER(LAST_NAME) = 'SCOTT'
  AND    ROWNUM = 1;

  OPEN v_cursor FOR
    SELECT
      ID,
      FIRST_NAME || ' ' || LAST_NAME  AS full_name,
      HIRE_DATE,
      JOB_TITLE
    FROM MyEmployee
    WHERE HIRE_DATE > v_scott_date;

  RETURN v_cursor;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: SCOTT was not found in MyEmployee.');
    RETURN NULL;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    RETURN NULL;
END F_HR_QUERY;
/

SET SERVEROUTPUT ON
DECLARE
  v_cur       SYS_REFCURSOR;
  v_id        NUMBER;
  v_name      VARCHAR2(100);
  v_hiredate  DATE;
  v_job       VARCHAR2(100);
BEGIN
  v_cur := F_HR_QUERY();
  LOOP
    FETCH v_cur INTO v_id, v_name, v_hiredate, v_job;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      'ID=' || v_id || '  ' || v_name ||
      '  Hired: ' || TO_CHAR(v_hiredate,'DD/MM/YYYY') ||
      '  Job: ' || NVL(v_job,'N/A')
    );
  END LOOP;
  CLOSE v_cur;
END;
/
