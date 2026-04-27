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
o	Columns to display: SALESPERSONS.empid, SALESPERSONS.ename, (SUM(ORDERITEMS.qty*INVENTORY.price) - SALESPERSONS.salary) 
o	Instructions: A salesperson's profit (or loss) is the difference between what the person sold and what the person earns ((SUM(ORDERITEMS.qty*INVENTORY.price) - SALESPERSONS.salary)).
o	If the value is positive then there is a profit, otherwise there is a loss. 
o	The most profitable salesperson, therefore, is the person with the greatest profit or smallest loss. 
o	The second-most profitable salesperson is the person with the next greatest profit or next smallest loss. 
o	Display the second-most profitable salesperson. 
o	Do not hard-code the results of #5 into this query - that simply creates a data-dependent query. 

*/
SELECT *
FROM(
SELECT *
FROM (
SELECT S.EmpID "Employee ID", 
       S.Ename "Employee Name", 
       TO_CHAR(NVL(SUM(OI.Qty*I.Price) - S.Salary,0),'$9999.99') "    Total"
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
WHERE ROWNUM <= 2
ORDER BY 3 DESC
)
WHERE ROWNUM = 1;