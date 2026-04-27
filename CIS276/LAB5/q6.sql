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
6.	Write a PL/SQL program that accepts (&empid) an empid from the keyboard using variable substitution, 
and displays the name, employee number, and salary of the salesperson with the empid.  
Use the OTHERS EXCEPTION to display the SQLERRM. 
Format your output line as “<ename> (employee <empid>) earns <salary>”,
 i.e. your output should look something like: 
SQL> @q2
Enter value for myempid: 109
Kevin Kody      (employee  109) earns   $3,410.00

PL/SQL procedure successfully completed.

*/
DECLARE
  vEName       SALESPERSONS.EName%TYPE;
  vSalary      SALESPERSONS.Salary%TYPE;

CURSOR c_mycursor IS
   SELECT  Ename,EmpID,Salary
   INTO    vEname,vEmpID,vSalary
   FROM    SALESPERSONS S
   WHERE   EmpID = &Enter_Employee_ID
   ORDER BY EmpID DESC;
   
BEGIN
  
   OPEN c_mycursor;
   FETCH c_mycursor INTO vEname,vEmpID,vSalary;
   WHILE c_mycursor%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE(vEname || 'Employee (' || vEmpID || ') earns ' || to_char(vSalary,'$9999'));                       
       FETCH c_mycursor INTO vEname,vEmpID,vSalary;

   END LOOP;
      
   CLOSE c_mycursor;
 
  
EXCEPTION

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 