/*
*******************************************************************************************
CIS276 at PCC
LAB 4 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [1/31/2016]

*******************************************************************************************
o	File to create: q8.sql 
o	Columns to display: none 
o	Instructions: Write an UPDATE query to increase the value of the SALESPERSONS.salary column by 9% for the most profitable salesperson(s).

*/
UPDATE SALESPERSONS
SET SALARY = (SELECT (MAX(SALARY)*1.09) FROM SALESPERSONS)
WHERE EMPID = 
(
SELECT EMPID
FROM (
  SELECT S.EmpID, 
         S.Ename, 
         SUM(OI.Qty*I.Price) - S.Salary
  FROM SALESPERSONS S,
       ORDERS O,
       ORDERITEMS OI,
       INVENTORY I
  WHERE  S.EmpID = O.EmpID
   AND   OI.OrderID = O.OrderID 
   AND   I.PartID = OI.PartID
  GROUP BY S.EmpID, S.Ename, S.Salary
  ORDER BY (SUM(OI.Qty*I.Price) - S.Salary) DESC
  )
WHERE ROWNUM = 1
);