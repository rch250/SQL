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

Write a PL/SQL Block that is given the four values, 
verifies that the customer is valid, 
verifies the orderid is in the orders table and is a valid order for this customer, 
verifies that the partid exists in inventory, verifies that the entered quantity is above zero,
and then calls the stored procedure (Lab7.sql). 
You can use the PL/SQL block that you wrote for the previous lab and modify it. 
It is in your best educational interest to change from nested to sequential or 
sequential to nested but you don't have to do this. 

You will want to approach this assignment in steps. 
Write the first trigger that does just part of the task. 
Then test it using code to UPDATE the INVENTORY table. 
Then incrementally add pieces to the project until you finally get to calling the stored procedure. 
 
Chapter 20 (?) in the textbook shows examples of stored procedures and triggers using PL/SQL in Oracle. 
A stored procedure allows you to pass parameters to the stored procedure. 
With a trigger the only data available to the trigger from outside the trigger is the row 
that is either being inserted, deleted or changed. 
Check out examples posted in this week's course materials. 

*/
DECLARE

   v_custID      CUSTOMERS.CUSTID%TYPE;
   v_orderID     ORDERS.ORDERID%TYPE;
   v_PartID      INVENTORY.PARTID%TYPE;
   v_qty         ORDERITEMS.QTY%TYPE;
   v_counter     NUMBER := 0;
   v_neworder    ORDERS.ORDERID%TYPE;
   v_detail      ORDERITEMS.DETAIL%TYPE;
   v_stockqty    INVENTORY.STOCKQTY%TYPE;
   ex_msg        VARCHAR(256) := 'unassigned';

   Invalid_Customer      EXCEPTION; 
   Invalid_Order         EXCEPTION;
   Invalid_Cust_Order    EXCEPTION;
   Invalid_PartID        EXCEPTION;
   Invalid_Qty           EXCEPTION;
   
   Invalid_StockQty      EXCEPTION;  
   PRAGMA EXCEPTION_INIT(Invalid_StockQty, -20000);
  
BEGIN
   v_custID  := &1;     -- Get customer ID from user
   v_orderID := &2;     -- Get order ID from user
   v_partID :=  &3;     -- Get Part ID from user
   v_qty :=     &4;     -- Get qty from user

   -- check CustID
   SELECT COUNT(*)
   INTO   v_counter
   FROM   CUSTOMERS
   WHERE  CUSTOMERS.custid = v_custid;
   
   IF v_counter = 0 THEN
      RAISE Invalid_Customer;
   END IF;
   
   -- check Order ID
   SELECT COUNT(*)
   INTO   v_counter
   FROM   ORDERS
   WHERE  ORDERS.orderID = v_orderID;
   
   IF v_counter = 0 THEN
      RAISE Invalid_Order;
   END IF;
   
    -- check Cust ID and Order ID
   SELECT COUNT(*)
   INTO   v_counter
   FROM   ORDERS
   WHERE  ORDERS.orderID = v_orderID
     AND  ORDERS.CUSTID = v_custID;
 
  IF v_counter = 0 THEN
      RAISE Invalid_Cust_Order;
   END IF; 
   
    -- check Part ID
   SELECT COUNT(*)
   INTO   v_counter
   FROM   INVENTORY
   WHERE  INVENTORY.PartID = v_PartID;
 
  IF v_counter = 0 THEN
      RAISE Invalid_PartID;
   END IF; 
   
  -- Add items to table
  AddLineItemSP (v_orderID,v_partID,v_qty);
   
  DBMS_OUTPUT.PUT_LINE('COMPLETED!');
  DBMS_OUTPUT.PUT_LINE('Customer: '   || To_char(v_CustID)  || 
                       ', order ID: ' || TO_CHAR(v_orderID) ||
                       ', Part ID: '  || TO_CHAR(v_PartID)  ||
                       ', Qty: '      || TO_CHAR(v_Qty)    );
  COMMIT;

EXCEPTION
    WHEN Invalid_Customer THEN
      DBMS_OUTPUT.PUT_LINE('CUSTOMER #' || to_char(v_custID) || ' DOES NOT EXIST');
      ROLLBACK;
    WHEN Invalid_Order THEN
      DBMS_OUTPUT.PUT_LINE('ORDER #' || to_char(v_orderID) || ' DOES NOT EXIST');
      ROLLBACK;
    WHEN Invalid_Cust_Order THEN
      DBMS_OUTPUT.PUT_LINE('ORDER #' || to_char(v_orderID) || ' DOES NOT EXIST for CUSTOMER #'
      || to_char(v_custID));
      ROLLBACK;
    WHEN Invalid_PartID THEN
      DBMS_OUTPUT.PUT_LINE('PART #' || to_char(v_PartID) || ' DOES NOT EXIST');
      ROLLBACK;
    WHEN Invalid_Qty THEN
      DBMS_OUTPUT.PUT_LINE('Invalid Quantity: ' || to_char(v_Qty) || ' <= 0');
      ROLLBACK;
    WHEN Invalid_StockQty THEN
      DBMS_OUTPUT.PUT_LINE('Lab7: Invalid Stock Quantity: ' || to_char(v_StockQty - v_qty) || ' <= 0 >- ROLLBACK!');
      ROLLBACK;
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Lab7: No data found');
       ROLLBACK;
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Lab7: UNKNOWN ERROR: ' || SQLERRM  || ' ' || SQLCODE);
       ROLLBACK;
END;
/



