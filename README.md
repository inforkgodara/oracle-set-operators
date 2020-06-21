# Oracle Set Operators

The set operators are used to combine the results of two component queries into a single result. Queries containing set operators are called compound queries.

## Setting up sample tables

We created two new tables departments and employees for the demonstration using Sample-tables.sql script. The SQL script is under followed.

```
-- Create DEPARTMENTS table
CREATE TABLE DEPARTMENTS (
  DEPARTMENT_ID   NUMBER(2) CONSTRAINT DEPARTMENTS_PK PRIMARY KEY,
  DEPARTMENT_NAME VARCHAR2(14),
  LOCATION        VARCHAR2(13)
);

-- Create EMPLOYEES table
CREATE TABLE EMPLOYEES (
  EMPLOYEE_ID   NUMBER(4) CONSTRAINT EMPLOYEES_PK PRIMARY KEY,
  EMPLOYEE_NAME VARCHAR2(10),
  JOB           VARCHAR2(9),
  MANAGER_ID    NUMBER(4),
  HIREDATE      DATE,
  SALARY        NUMBER(7,2),
  COMMISSION    NUMBER(7,2),
  DEPARTMENT_ID NUMBER(2) CONSTRAINT EMP_DEPARTMENT_ID_FK REFERENCES DEPARTMENTS(DEPARTMENT_ID)
);

-- Insert data into DEPARTMENTS table
INSERT INTO DEPARTMENTS VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPARTMENTS VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPARTMENTS VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPARTMENTS VALUES (40,'OPERATIONS','BOSTON');

-- Insert data into EMPLOYEES table
INSERT INTO EMPLOYEES VALUES (7369,'SMITH','CLERK',7902,TO_DATE('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMPLOYEES VALUES (7499,'ALLEN','SALESMAN',7698,TO_DATE('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMPLOYEES VALUES (7521,'WARD','SALESMAN',7698,TO_DATE('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMPLOYEES VALUES (7566,'JONES','MANAGER',7839,TO_DATE('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMPLOYEES VALUES (7654,'MARTIN','SALESMAN',7698,TO_DATE('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMPLOYEES VALUES (7698,'BLAKE','MANAGER',7839,TO_DATE('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMPLOYEES VALUES (7782,'CLARK','MANAGER',7839,TO_DATE('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMPLOYEES VALUES (7788,'SCOTT','ANALYST',7566,TO_DATE('13-JUL-87','dd-mm-rr')-85,3000,NULL,20);
INSERT INTO EMPLOYEES VALUES (7839,'KING','PRESIDENT',NULL,TO_DATE('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMPLOYEES VALUES (7844,'TURNER','SALESMAN',7698,TO_DATE('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMPLOYEES VALUES (7876,'ADAMS','CLERK',7788,TO_DATE('13-JUL-87', 'dd-mm-rr')-51,1100,NULL,20);
INSERT INTO EMPLOYEES VALUES (7900,'JAMES','CLERK',7698,TO_DATE('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMPLOYEES VALUES (7902,'FORD','ANALYST',7566,TO_DATE('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMPLOYEES VALUES (7934,'MILLER','CLERK',7782,TO_DATE('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
```

## UNION

The UNION set operator returns all distinct rows selected by either query. That means any duplicate rows will be removed.

In the example below, notice there is only a single row each for departments 20 and 30, rather than two each.

```
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID <= 30
UNION
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY 1;

DEPARTMENT_ID DEPARTMENT_NAM
------------- --------------
           10 ACCOUNTING
           20 RESEARCH
           30 SALES
           40 OPERATIONS

4 rows selected.
```

## UNION ALL

The UNION ALL set operator returns all rows selected by either query. That means any duplicates will remain in the final result set.

In the example below, notice there are two rows each for departments 20 and 30.

```
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID <= 30
UNION ALL
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY 1;

DEPARTMENT_ID DEPARTMENT_NAM
------------- --------------
           10 ACCOUNTING
           20 RESEARCH
           20 RESEARCH
           30 SALES
           30 SALES
           40 OPERATIONS

6 rows selected.
```

## INTERSECT

The INTERSECT set operator returns all distinct rows selected by both queries. That means only those rows common to both queries will be present in the final result set.

In the example below, notice there is one row each for departments 20 and 30, as both these appear in the result sets for their respective queries.

```
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID <= 30
INTERSECT
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY 1;

DEPARTMENT_ID DEPARTMENT_NAM
------------- --------------
           20 RESEARCH
           30 SALES

2 rows selected.
```

## MINUS

The MINUS set operator returns all distinct rows selected by the first query but not the second. This is functionally equivalent to the ANSI set operator EXCEPT DISTINCT.

In the example below, the first query would return departments 10, 20, 30, but departments 20 and 30 are removed because they are returned by the second query. This leaves a single rows for department 10.

```
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID <= 30
MINUS
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY 1;

DEPARTMENT_ID DEPARTMENT_NAM
------------- --------------
           10 ACCOUNTING

1 row selected.
```

Note: The ORDER BY clause is applied to all rows returned in the final result set. Columns in the ORDER BY clause can be referenced by column names or column aliases present in the first query of the statement, as these carry through to the final result set. Typically, you will see people use the column position as it is less confusing when the data is sourced from different locations for each query block.

```
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 10
UNION ALL
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY EMPLOYEE_ID;

EMPLOYEE_ID EMPLOYEE_NAME
----------- --------------
         20 RESEARCH
         30 SALES
         40 OPERATIONS
       7782 CLARK
       7839 KING
       7934 MILLER

6 rows selected.
```
