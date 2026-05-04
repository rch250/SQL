/*
*******************************************************************************************
CIS276 at PCC
LAB 7 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [2/28/2016]

*******************************************************************************************
Write a stored procedure that adds a lineitem into an order that already exists (AddLineItemSP.sql). 
This stored procedure will receive three parameters:  an orderid, a partid and a quantity. 

Issue an INSERT to the ORDERITEMS table. 

When the INSERT is executed, the trigger on INSERT for the ORDERITEM table will be fired.  
Since the value of the Detail column will be determined inside of the INSERT trigger, 
you will need to provide column names on the INSERT command for just the three columns that you have data for. 

Remember that when you write an INSERT where the values inserted do not include every column in the table, 
you need to include the column names with the INSERT.

Exception handling must be included. 
If you attempt to INSERT a partid that does not exist, 
a system exception will be invoked based on the foreign key constraint. 
*/
Create or replace PROCEDURE AddLineItemSP (v_orderID ORDERS.ORDERID%TYPE, 
                                           v_partID INVENTORY.PARTID%TYPE, 
                                           v_qty ORDERITEMS.QTY%TYPE) IS

  Invalid_StockQty      EXCEPTION;
  PRAGMA EXCEPTION_INIT(Invalid_StockQty, -20000);
  
BEGIN
  INSERT INTO ORDERITEMS
    (orderid, Partid, qty)
  VALUES
   (v_orderID, v_PartID, v_qty);
   
   
  EXCEPTION 
    WHEN Invalid_StockQty THEN
      DBMS_OUTPUT.PUT_LINE('AddLineItemSP: Invalid stock_qty for orderID ' || v_orderID); 
      RAISE;
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('AddLineItemSP: No data found');
      RAISE;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('AddLineItemSP: Error adding orderID ' || v_orderID || ': ' || SQLERRM);
      RAISE;
END AddLineItemSP;
