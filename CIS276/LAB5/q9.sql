/*
*******************************************************************************************
CIS276 at PCC
LAB 5 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [2/7/2016]

*******************************************************************************************
9.	Write a PL/SQL program to input a custid (&Custid).  
Display the customer’s name, and the orderid, salesdate, and total value of each order for that customer.  
Produce the output in descending order by total value of each order. 
This output will produce one or more lines for the customer, depending on how many orders that customer has made. 
Test your program with a good custid, 
a custid that is not in the CUSTOMERS table, 
and one that is in the CUSTOMERS table but has no orders.  
Be sure to distinguish between the customer that does not exist and a customer that exists but has no orders 
(as above: display different output for each situation).  
Use the NO_DATA_FOUND and OTHERS exception handlers. 
*/
DECLARE
  vCName       CUSTOMERS.CNAME%TYPE;
  vOrderID     ORDERS.ORDERID%TYPE;
  vSalesDate   ORDERS.SALESDATE%TYPE;
  vTotal       NUMBER;
  
    CURSOR c_mycursor IS
    
      SELECT C.CNAME, O.OrderID, O.SalesDate, NVL(SUM(OI.Qty * I.Price),0)
      INTO   vCName, vOrderID, vSalesDate, vTotal
      FROM CUSTOMERS C, ORDERS O, ORDERITEMS OI, INVENTORY I
      WHERE    C.CustID = O.CustID(+)
          AND  O.OrderID = OI.OrderID(+)
          AND  I.PartID(+) = OI.PartID
          AND  C.CustID =  &Enter_Customer_ID
      GROUP BY C.CNAME, O.OrderID, O.SalesDate
      ORDER BY NVL(SUM(OI.Qty * I.Price),0) DESC;
    
BEGIN
   
   OPEN c_mycursor;
   FETCH c_mycursor INTO vCName, vOrderID, vSalesDate, vTotal;
   WHILE c_mycursor%FOUND LOOP
             IF vTotal > 0
             THEN DBMS_OUTPUT.PUT_LINE(vCName || to_char(vOrderID,'9999') || '    ' || 
                            to_char(vSalesDate,'mm/dd/yyyy')  || to_char(vTotal,'$9999'));  
             ELSE DBMS_OUTPUT.PUT_LINE(vCName || ' placed no orders');
          END IF;               
       FETCH c_mycursor INTO vCName, vOrderID, vSalesDate, vTotal;                
   END LOOP;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('specified number does not exist');
     vCName := 'No such person';
     
   WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 