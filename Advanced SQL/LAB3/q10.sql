
SELECT   S.Ename "Employee Name"
FROM     SALESPERSONS S, ORDERS O 
WHERE    S.EmpID = O.EmpID(+) 
         AND O.EmpID IS NULL     -- to eliminate those (rows) with sales
ORDER BY S.Ename ASC;