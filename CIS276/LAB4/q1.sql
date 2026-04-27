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
1.	Who are the profit-less customers? 
o	File to create: q1.sql 
o	Columns to display: CUSTOMERS.custid, CUSTOMERS.cname 
o	Instructions: Display the customers that have not placed orders.   
o	Show in customer name order.
o	Use the EXISTS (or NOT EXISTS) clause. 

*/
SELECT C.CustID "Cust ID", C.Cname "Customer Name"
FROM CUSTOMERS C
WHERE  NOT EXISTS
  (SELECT O.CustID
  FROM ORDERS O
  WHERE O.CustID = C.CustID)
ORDER BY C.CustID;