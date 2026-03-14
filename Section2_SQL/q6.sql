CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM user_tables
  WHERE UPPER(table_name) = 'MYEMPLOYEE_UPDATE';

  IF v_count > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE MyEmployee_update PURGE';
    DBMS_OUTPUT.PUT_LINE('Old MyEmployee_update dropped.');
  END IF;

  EXECUTE IMMEDIATE
    'CREATE TABLE MyEmployee_update AS SELECT * FROM MyEmployee';

  EXECUTE IMMEDIATE
    'SELECT COUNT(*) FROM MyEmployee_update'
    INTO v_count;

  DBMS_OUTPUT.PUT_LINE('P_COPY_EMPLOYEE complete. Rows copied: ' || TO_CHAR(v_count));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END P_COPY_EMPLOYEE;
/

SET SERVEROUTPUT ON
BEGIN
  P_COPY_EMPLOYEE();
END;
/

SELECT COUNT(*) AS rows_in_backup FROM MyEmployee_update;
SELECT * FROM MyEmployee_update;
