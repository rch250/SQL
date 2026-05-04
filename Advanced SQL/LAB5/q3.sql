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
3.	Write a PL/SQL program that includes an SQL statement that finds the partid, description, 
and price of the highest priced item in our inventory. 
Format your output line as "Part Number <vPartid> described as <vDescription> is the highest priced item in inventory at <vPrice>". 
Do not handle the case of there being two parts with the same, highest price - save that for the next question. Use the OTHERS EXCEPTION to display the SQLERRM. 
Your output line should look like the following: 

 Part Number 9999 described as XXXXXX is the highest priced item in inventory at $9999.999 
*/
DECLARE

   vPartid       INVENTORY.PartId%TYPE;
   vCost         INVENTORY.PRICE%TYPE;
   
BEGIN
  
   SELECT  PartID, Price
   INTO    vPartid, vCost
   FROM    INVENTORY I
   WHERE   I.Price = (SELECT MAX(Price)
                     FROM INVENTORY);
   
   DBMS_OUTPUT.PUT_LINE(to_char(vPartid, '9999') || ' is the highest priced item in inventory at ' 
                       || to_char(vCost,'$9999.99'));

EXCEPTION

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 