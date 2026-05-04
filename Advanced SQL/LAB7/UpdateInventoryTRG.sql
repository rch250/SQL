CREATE OR REPLACE TRIGGER t_UpdateInventory BEFORE UPDATE ON INVENTORY
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
Write a trigger on the UPDATE command of the INVENTORY table (UpdateInventoryTRG.sql). 
This trigger will check to see if the stockqty of the part being ordered is enough to meet 
the new lineitem quantity. 

If the stockqty is not large enough, raise a user defined exception. 

This requires that you declare a user defined exception in the UPDATE trigger 
and also in any module where you wish the exception to be raised. 
*/

DECLARE  
  Invalid_StockQty      EXCEPTION;
  PRAGMA EXCEPTION_INIT(Invalid_StockQty, -20000);
   
BEGIN
   DBMS_OUTPUT.PUT_LINE('t_UpdateInventory: :NEW.StockQty ' || :NEW.StockQty);
    
   IF :NEW.StockQty < 0 
     THEN
       RAISE Invalid_StockQty;
   END IF;

  EXCEPTION
    WHEN Invalid_StockQty THEN
      DBMS_OUTPUT.PUT_LINE('t_UpdateInventory: Invalid stock_qty for PartID ' || :OLD.PartID);
      RAISE;
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('t_UpdateInventory: No data found');
       RAISE;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('t_UpdateInventory: Error updating for  ' || :OLD.PartID || ': '
         || SQLERRM);
      RAISE;

END;

   
   