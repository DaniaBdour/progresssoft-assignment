CREATE TABLE emp (
  empno  NUMBER PRIMARY KEY,
  ename  VARCHAR2(50),
  salary NUMBER
);

INSERT INTO emp VALUES (1, 'SCOTT', 3000);
INSERT INTO emp VALUES (2, 'JOHN',  2500);
INSERT INTO emp VALUES (3, 'SARA',  4000);
COMMIT;

SELECT empno,
       ename,
       salary * 12 AS "ANNUAL SALARY"
FROM emp;
