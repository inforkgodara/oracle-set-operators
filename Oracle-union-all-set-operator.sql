-- Select rows from DEPARTMENTS table using oracle union all set operator.

SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID <= 30
UNION ALL
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM   DEPARTMENTS
WHERE  DEPARTMENT_ID >= 20
ORDER BY 1;