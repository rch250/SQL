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
4.	What would happen if there were two or more items that have that same highest price?  
(Let's say that the highest price is $80 and there are two or more items that have that price.)  
Write the PL/SQL program that would handle this situation.  
This requires using a CURSOR and a LOOP with a FETCH.  
Use the OTHERS EXCEPTION to display the SQLERRM. Test your code for more than one item with the highest price.  
Update your table in order to test this condition (you can change a price in one of the already existing partid's to match the maximum price, or INSERT a new row).
*/
DECLARE
  vCost         INVENTORY.PRICE%TYPE;
  vPartid       INVENTORY.PartId%TYPE;
 
CURSOR c_mycursor IS
   SELECT  PartID, Price
   INTO    vPartid, vCost
   FROM    INVENTORY I
   WHERE   I.Price = (SELECT MAX(Price)
                     FROM INVENTORY);
   
BEGIN
  
   OPEN c_mycursor;
   FETCH c_mycursor INTO vPartID, vCost;
   WHILE c_mycursor%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE(to_char(vPartid, '9999') || ' is the highest priced item in inventory at ' 
                       || to_char(vCost,'$9999.99'));
                       
       FETCH c_mycursor INTO vPartID, vCost;

   END LOOP;
      
   CLOSE c_mycursor;
 
  
EXCEPTION

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 