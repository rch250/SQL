CREATE OR REPLACE TRIGGER t_InsertOrderItems BEFORE INSERT ON ORDERITEMS
FOR EACH ROW

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
Write a trigger on the INSERT command of the ORDERITEMS table (InsertOrderitemsTRG.sql).  

In this trigger you will determine the value of the column named Detail, 
which is one more than the last Detail for that Orderid (remember to code for no existing detail lines). 
One of the beauties of Oracle triggers is that you can assign a value to the newly inserted row.  
You can access the new row inside the trigger.  

Also, in this trigger you will UPDATE the inventory table to reduce the stockqty 
of the partid being ordered by the amount in the new lineitem.  
Exception handling must be included. 
*/

DECLARE
  Invalid_StockQty      EXCEPTION;
  PRAGMA EXCEPTION_INIT(Invalid_StockQty, -20000);
  
BEGIN
   SELECT NVL(MAX(Detail)+1, 1)
   INTO   :NEW.Detail
   FROM   ORDERITEMS OI
   WHERE  OI.OrderID =  :NEW.OrderID;

   DBMS_OUTPUT.PUT_LINE('t_InsertOrderItems: :NEW.Detail: ' || :NEW.Detail ||  
                         ' :NEW.OrderID: '  || :NEW.OrderID ||
                         ' :NEW.Qty: '  || :NEW.Qty ||
                         ' :NEW.PartID: '  || :NEW.PartID);
   
   UPDATE INVENTORY
   SET StockQty = StockQty - :NEW.Qty  
   WHERE PartID = :NEW.PartID;
   
   EXCEPTION
     WHEN Invalid_StockQty THEN
        DBMS_OUTPUT.PUT_LINE('t_InsertOrderItems: Invalid stock_qty for PartID ' || :NEW.PartID); 
        RAISE;
     WHEN NO_DATA_FOUND THEN 
       DBMS_OUTPUT.PUT_LINE('t_InsertOrderItems: No data found');
       RAISE;
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('t_InsertOrderItems: Error updating PartID ' || :OLD.PartID || ': '
           || SQLERRM);
        RAISE;
END;     