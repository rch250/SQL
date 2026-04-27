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
2.	Write a PL/SQL program that will include an SQL statement that finds the 
description and price for partid 1001.  
Declare variables vDescription and vPrice to hold the values you find; 
use another variable vPartid to store the partid above.  
Embed an SQL statement that will select the description 
and price values from the inventory table INTO the variables vDescription and vPrice.  
The WHERE clause should not check for the constant 1001, 
but rather check for the value in the variable vPartid. 
Use the OTHERS EXCEPTION to display the SQLERRM. 
Format your output line as 
"Part Number <vPartid> has a description of <vDescription> and costs <vPrice>". 
Your output line should look like:
Part Number 1001 has a description of doodad and costs $10.00
*/
DECLARE

   vPartid       INVENTORY.PartId%TYPE := 1001;
   vDescription  INVENTORY.Description%TYPE;
   vCost         INVENTORY.PRICE%TYPE;
   
BEGIN

   SELECT  PartID, Description, Price
   INTO    vPartid, vDescription, vCost
   FROM    INVENTORY
   WHERE   PartID = vPartID;
   
   DBMS_OUTPUT.PUT_LINE(to_char(vPartid, '9999') || ' has a description of ' 
                       || vDescription || ' and costs ' || to_char(vCost,'$9999.99'));


EXCEPTION

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 