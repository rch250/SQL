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
o	File to create:  q9.sql 
o	Columns to display: none 
o	Instructions: Write a DELETE query to delete rows from the ORDERS table that are not associated with any rows in ORDERITEMS (i.e. remove the orders with no line items). 

*/
DELETE FROM ORDERS O
WHERE  NOT EXISTS
  (SELECT OrderID
  FROM ORDERITEMS OI
  WHERE OI.OrderID = O.OrderID);