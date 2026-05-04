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
o	File to create: q3.sql 
o	Columns to display: SALESPERSONS.empid, SALESPERSONS.ename, SUM(ORDERITEMS.qty*INVENTORY.price) 
o	Instructions: Display the total dollar value that each and every sales person has sold. 
o	If you want to show zero use NVL. 
o	List in descending order of  total amount sold. 

*/
SELECT S.EmpID "Employee ID", 
       S.Ename "Employee Name", 
       TO_CHAR(NVL(SUM(OI.Qty*I.Price),0),'$9999.99') "    Total"
FROM SALESPERSONS S LEFT JOIN ORDERS O
        ON S.EmpID = O.EmpID
	 LEFT JOIN ORDERITEMS OI
	    ON OI.OrderID = O.OrderID 
	 LEFT JOIN INVENTORY I
	    ON I.PartID = OI.PartID
GROUP BY S.EmpID, S.Ename
ORDER BY  SUM(OI.Qty*I.Price) DESC;