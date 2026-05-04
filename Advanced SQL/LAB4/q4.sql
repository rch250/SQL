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
o	File to create: q4.sql 
o	Columns to display: ORDERS.orderid, SUM(ORDERITEM.qty*INVENTORY.price) 
o	Instructions: Display the total value of each and every order.
o	If you want to show zero use NVL.
*/
SELECT O.OrderID "OrderID",
       TO_CHAR(NVL(SUM(OI.Qty*I.Price),0),'$9999.99') "    Total"
FROM ORDERS O,
     ORDERITEMS OI,
	 INVENTORY I
WHERE  OI.OrderID = O.OrderID 
 AND   I.PartID = OI.PartID
GROUP BY O.OrderID
ORDER BY  SUM(OI.Qty*I.Price) DESC;