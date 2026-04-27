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
1.	Write a PL/SQL program that will declare two variables, vPartid and vDescription, 
and assign each values of 5001 and 'Gonzo' respectively.  
Format your output line as "Part Number <vPartid> has a description of <vDescription>". 
No exception processing needed. 
Note: this does not require a SQL statement. 
Produce an output line that looks like the following line:
*/
DECLARE

   vPartid   NUMBER := 5001;
   vDescription VARCHAR(256) := 'Gonzo';

BEGIN
   
   DBMS_OUTPUT.PUT_LINE( vPartid || ' has a description of ' || vDescription);

END;
/
 