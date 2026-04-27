/*
*******************************************************************************************
CIS276 at PCC
LAB 6 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [2/21/2016]

*******************************************************************************************
(Task #1 - 40 points)  Your submission file named Lab6.sql is to contain a PL/SQL program to process a transaction that 
includes multiple updates to the SalesDB database. Use COMMIT and ROLLBACK in appropriate logic and handle EXCEPTIONs.
 
The transaction logic will add a new lineitem (INSERT) to an already existing order. 
The scenario could be that a customer has previously placed an order and now wishes to add another item to the order. This could happen by a phone call or a web connection. The input data for this transaction will be the CustID, the Orderid, the Partid and Quantity for the new lineitem (in that order). After the new lineitem has been inserted, the INVENTORY table must be updated to reflect the change in the Stockqty for the partid on the new lineitem.
 After that UPDATE, check the value of the stockqty. If it is a negative number there is not enough stock to sell so the transaction needs to be rolled back. We can leave a zero balance in stock although that puts the quantity under the reorder point.

Your program will need to do the following (and in this order): 

1.	Accept data when Lab6 is run. 
You will do this by assignment of the sequence number for the data in this order: 
custid, orderid, partid, quantity. 
This means you will use the anpersand (&) and a number from 1 to 4 for assignment to your variables. 
Example: inQty :=&4; can be used in the DECLARE section or at the beginning of the program code 
and represents the expectation that quantity will be the fourth item given to run Lab6. 
Code to run Lab6 will be @Lab6 1 6099 1001 15; 
that represents the users desire to add a new lineitem for customer 1 on order 6099 consisting of part 1001 and an amount of 15.
2.	Verify that the customer exists. 
Provide a user-defined exception that displays a message if it does not exist. 
This program will not be adding new customers.
3.	Verify that the orderid exists. Provide a user-defined exception that displays a message if it does not exist. 
This program will not be adding new orders.
4.	Verify the customer has the order (the order does not belong to another customer). 
Process a user-defined exception that will display a message telling the user that the combination of custid and orderid is incorrect.
5.	Verify that the partid exists. Provide a user-defined exception that displays a message if it does not exist. 
This program will not be adding new items to inventory.
6.	Verify that the quantity entered is more than zero. 
Provide a user-defined exception to display a message if quantity entered is not one or more.
7.	When all of the above validate, 
INSERT the new lineitem, determining the value of the Detail column as MAX(Detail)+1 for this orderid in the ORDERITEMS table. 
You need to code for the possibility that an order may not have detail lines and the inserted lineitem will need detail number one.
8.	UPDATE the INVENTORY table to reduce the Stockqty by the amount of the new order. 
9.	Check to see if the new Stockqty is less than zero, if it is handle another user-defined exception that displays a failure message and then performs a ROLLBACK.
10.	If there are no errors/exceptions at this point, do a COMMIT. Display a message of success.
•	Ensure system generated EXCEPTIONs display an appropriate error message and include the display of SQLCODE and SQLERRM along with your message.
•	Think about how you will process data validation with the system generated exception, NO_DATA_FOUND, that will apply for every query returning zero rows and then with your user-defined exception handlers that provide information to the user for the specific problem.

The order of actions above is the way you are to write your logic. This will guarantee that you experience the ROLLBACK and COMMIT commands. Write your program in blocks of code (use either nested blocks or sequential blocks or a combination of both). Each PL/SQL block will have it's own EXCEPTION handler and you will RAISE the user-defined exceptions as needed within the program. Lab6 is a standalone program and as such will use exceptions that don't get raised to outside programs.

(Task #2 - 10 points) Testing is an important part of programming!  Make a test plan. This includes a statement of what you are testing and with what data you are using to perform the test. The submission file named Test6.sql is a script containing your tests on your program, Lab6. YOU will need to determine what tests need to be done. The test plan is the most important part of this task. Coding the test script (Test6.sql) is minor and you can see past grading scripts for examples. 

Use queries to display appropriate before and after data. If your tests are set up in a good sequence, you won't have to reset the tables. You may, however,  include resets and/or updates to your tables in your test script to show your testing skills. It is important for you to have a complete test plan -- ensure all possible problems are tested (you don't want to be called in the middle of the night because your program balked with an unknown exception). You may want/need to add new CUSTOMERS, ORDERS, and/or INVENTORY within your testing but your program, Lab6, will not be doing this.

Remember this is not a representation of reality but a way for us to learn so that we can code for real when we code for our jobs. If some of the instructions don't make sense in a realistic way or for a real-world situation that is okay, we are in school and need to learn concepts.
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
   NODATA                EXCEPTION;
  
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
   
    -- check Cust ID and Order ID
   SELECT COUNT(*)
   INTO   v_counter
   FROM   INVENTORY
   WHERE  INVENTORY.PartID = v_PartID;
 
  IF v_counter = 0 THEN
      RAISE Invalid_PartID;
   END IF; 
   
      -- check qty
   IF v_qty <= 0 THEN
      RAISE Invalid_Qty;
   END IF; 
   
   -- get next detail for order
   BEGIN
     ex_msg := 'get next detail';
     SELECT NVL(MAX(detail)+1, 1)
     INTO   v_detail
     FROM   ORDERITEMS OI
     WHERE  OI.OrderID = v_OrderID;
     
     EXCEPTION 
         WHEN NO_DATA_FOUND THEN 
            RAISE NoDATA; 
 
   END;
   
-- insert order
  BEGIN
    INSERT INTO ORDERITEMS
      (orderid, detail, Partid, qty)
    VALUES
     (v_orderID, v_detail, v_PartID, v_qty);
     
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
        RAISE NoData;
      
  END;
  
  -- check new stock qty
   BEGIN
     ex_msg := 'stockqty';
     SELECT StockQty
     INTO v_StockQty
     FROM INVENTORY
     WHERE PartID = v_PartID;
     
     EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
          RAISE NoData; 
          
   END;
   
   IF (v_StockQty - v_Qty) >= 0 
     THEN
       UPDATE INVENTORY
       SET StockQty = StockQty - v_Qty
       WHERE PartID = v_PartID;
     ELSE RAISE Invalid_StockQty;
   END IF;
    
  DBMS_OUTPUT.PUT_LINE('COMPLETED!');
  DBMS_OUTPUT.PUT_LINE('Customer: '   || To_char(v_CustID)  || 
                       ', order ID: ' || TO_CHAR(v_orderID) ||
                       ', Part ID: '  || TO_CHAR(v_PartID)  ||
                       ', Qty: '      || TO_CHAR(v_Qty)     ||
                       ', Detail: '   || TO_CHAR(v_Detail)  ||
                      ',  New Stock qty: '   || TO_CHAR(v_StockQty - v_Qty)
                       );
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
      DBMS_OUTPUT.PUT_LINE('Invalid Stock Quantity: ' || to_char(v_StockQty - v_qty) || ' <= 0 >- ROLLBACK!');
      ROLLBACK;
    WHEN NODATA THEN
       DBMS_OUTPUT.PUT_LINE('No data found for: ' || ex_msg);
       ROLLBACK;
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR: ' || SQLERRM  || ' ' || SQLCODE);
       ROLLBACK;
END;
/



