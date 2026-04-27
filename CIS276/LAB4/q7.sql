/*
*******************************************************************************************
CIS276 at PCC
LAB 4 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [1/31/2016]

*******************************************************************************************
o	File to create:  q7.sql 
o	Columns to display: none 
o	Instructions: Write an INSERT query to insert a new salesperson into the database with the following attribute values.
?	empid should be one greater than the largest existing empid (no hard-coding, use SELECT)
?	ename should be your name (hard-code your name here) 
?	rank should be whichever rank is associated with the lowest-paid salesperson (use SELECT).
?	salary is to be 9% more than the lowest-paid salesperson (another SELECT clause). 

*/
INSERT INTO SALESPERSONS
   (EMPID, ENAME, RANK, SALARY)
VALUES
   ((SELECT MAX(EMPID) + 1 FROM SALESPERSONS),   
     'Robert Heintze',  
     (SELECT MIN(RANK) FROM SALESPERSONS), 
     (SELECT MIN(SALARY)*1.09 FROM SALESPERSONS)
     );
   
