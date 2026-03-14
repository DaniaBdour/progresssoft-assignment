-- MySQL does not have NUMBER, use INT or DECIMAL
-- MySQL does not have VARCHAR2, use VARCHAR
-- MySQL does not have TO_DATE, use STR_TO_DATE
-- MySQL does not have BLOB for images, use LONGBLOB
-- MySQL does not have DUAL

-- ════════════════════════════
-- TABLE 1: Gender
-- ════════════════════════════
CREATE TABLE Gender (
  Gender_ID  INT          PRIMARY KEY,
  Name       VARCHAR(20)  NOT NULL,
  CONSTRAINT ck_gender CHECK (Name IN ('Male','Female','Other'))
);

INSERT INTO Gender VALUES (1, 'Male');
INSERT INTO Gender VALUES (2, 'Female');
INSERT INTO Gender VALUES (3, 'Other');
COMMIT;

-- ════════════════════════════
-- TABLE 2: University
-- ════════════════════════════
CREATE TABLE University (
  ID    INT           PRIMARY KEY,
  Name  VARCHAR(200)  NOT NULL UNIQUE
);

INSERT INTO University VALUES (1, 'University of Jordan');
INSERT INTO University VALUES (2, 'Jordan University of Science and Technology');
INSERT INTO University VALUES (3, 'German Jordanian University');
COMMIT;

-- ════════════════════════════
-- TABLE 3: MyDepartment
-- ════════════════════════════
CREATE TABLE MyDepartment (
  Dept_ID  INT           PRIMARY KEY,
  Name     VARCHAR(100)  NOT NULL UNIQUE
);

INSERT INTO MyDepartment VALUES (10, 'IT');
INSERT INTO MyDepartment VALUES (20, 'HR');
INSERT INTO MyDepartment VALUES (30, 'Finance');
INSERT INTO MyDepartment VALUES (40, 'Sales');
COMMIT;

-- ════════════════════════════
-- TABLE 4: MyEmployee
-- ════════════════════════════
CREATE TABLE MyEmployee (
  ID            INT              PRIMARY KEY,
  LAST_NAME     VARCHAR(50)      NOT NULL,
  FIRST_NAME    VARCHAR(50)      NOT NULL,
  HIRE_DATE     DATE             NOT NULL,
  USERID        INT              NOT NULL UNIQUE,
  SALARY        DECIMAL(10,2)    NOT NULL,
  DEPT_ID       INT,
  Gender_ID     INT,
  University_ID INT,
  MANAGER_ID    INT,
  JOB_TITLE     VARCHAR(100),
  EMP_IMAGE     LONGBLOB,
  CONSTRAINT ck_salary     CHECK (SALARY > 0),
  CONSTRAINT fk_emp_dept   FOREIGN KEY (DEPT_ID)       REFERENCES MyDepartment(Dept_ID),
  CONSTRAINT fk_emp_gender FOREIGN KEY (Gender_ID)     REFERENCES Gender(Gender_ID),
  CONSTRAINT fk_emp_univ   FOREIGN KEY (University_ID) REFERENCES University(ID),
  CONSTRAINT fk_emp_mgr    FOREIGN KEY (MANAGER_ID)    REFERENCES MyEmployee(ID)
);

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,JOB_TITLE)
VALUES
  (1,'SCOTT','John',STR_TO_DATE('09/09/1987','%d/%m/%Y'),1001,5000,10,1,1,'Manager');

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,MANAGER_ID,JOB_TITLE)
VALUES
  (2,'Ahmad','Ali',STR_TO_DATE('10/10/1980','%d/%m/%Y'),1002,2500,20,1,2,1,'HR Specialist');

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,MANAGER_ID,JOB_TITLE)
VALUES
  (3,'Rami','Sami',STR_TO_DATE('24/05/1986','%d/%m/%Y'),1003,2800,10,1,1,1,'Engineer');

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,MANAGER_ID,JOB_TITLE)
VALUES
  (4,'Khaled','Omar',STR_TO_DATE('15/03/1990','%d/%m/%Y'),1004,3200,30,1,3,1,'Financial Analyst');

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,MANAGER_ID,JOB_TITLE)
VALUES
  (5,'Sara','Noor',STR_TO_DATE('20/07/1995','%d/%m/%Y'),1005,2200,40,2,2,1,'Sales Representative');

INSERT INTO MyEmployee
  (ID,LAST_NAME,FIRST_NAME,HIRE_DATE,USERID,SALARY,DEPT_ID,Gender_ID,University_ID,MANAGER_ID,JOB_TITLE)
VALUES
  (6,'Lina','Hana',STR_TO_DATE('11/02/1992','%d/%m/%Y'),1006,3100,10,2,3,1,'Engineer');

COMMIT;
