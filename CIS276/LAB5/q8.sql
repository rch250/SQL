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
8.	Write a PL/SQL program using a CURSOR for the same problem as #7 above. 
Do all the same tests as #7 and hopefully get the same results! 

Test your program with a good customer id, 
a customer id that does not exist in the database, 
and a customer id that exists in the database but has no orders.

Use the NO_DATA_FOUND and OTHERS exception handlers. 
The customer that has no orders can be checked using %ROWCOUNT in a condition. 
*/
DECLARE
  vCustID      CUSTOMERS.CustID%TYPE;
  vCName       CUSTOMERS.CNAME%TYPE;
  vTotal       NUMBER;
  
  
  
    CURSOR c_mycursor IS
    
      SELECT C.CNAME, NVL(SUM(OI.Qty * I.Price),0)
      INTO vCName, vTotal
      FROM CUSTOMERS C, ORDERS O, ORDERITEMS OI, INVENTORY I
      WHERE    C.CustID = O.CustID(+)
          AND  O.OrderID = OI.OrderID(+)
          AND  I.PartID(+) = OI.PartID
          AND  C.CustID =  &Enter_Customer_ID
      GROUP BY C.CNAME;
    
BEGIN
   
   OPEN c_mycursor;
   FETCH c_mycursor INTO vCName,vTotal;
   WHILE c_mycursor%FOUND LOOP
   
          IF vTotal > 0
             THEN DBMS_OUTPUT.PUT_LINE(vCName || ' ordered ' || to_char(vTotal,'$9999'));
             ELSE DBMS_OUTPUT.PUT_LINE(vCName || ' placed no orders');
          END IF;               
       FETCH c_mycursor INTO vCName,vTotal;                
   END LOOP;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('specified number does not exist');
     vCName := 'No such person';
     
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 