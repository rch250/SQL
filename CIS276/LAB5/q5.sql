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
5.	Write a PL/SQL program that displays the name, employee number, and salary of all salespersons in descending order of salary.  
This requires using a CURSOR and a LOOP with a FETCH. Use the OTHERS EXCEPTION to display the SQLERRM. 
Format your output line as “<ename> - <empid> <salary>”, i.e. your output should look something like the following:
109 - Kevin Kody        $3,100.00
108 - Harvey Harrison   $3,000.00
107 - Gloria Garcia     $2,500.00
106 - Faulkner Forest   $2,500.00
105 - Edward Everling   $2,200.00
104 - Dale Dahlman      $2,000.00
103 - Charles Cox       $2,000.00
110 - Larry Little      $1,500.00
102 - Burbank Burkett   $1,000.00
101 - Andrew Allen      $1,000.00

*/
DECLARE
  vEName       SALESPERSONS.EName%TYPE;
  vEmpID       SALESPERSONS.EmpID%TYPE;
  vSalary      SALESPERSONS.Salary%TYPE;

 
CURSOR c_mycursor IS
   SELECT  Ename,EmpID,Salary
   INTO    vEname,vEmpID,vSalary
   FROM    SALESPERSONS S
   ORDER BY EmpID DESC;
   
BEGIN
  
   OPEN c_mycursor;
   FETCH c_mycursor INTO vEname,vEmpID,vSalary;
   WHILE c_mycursor%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE(to_char(vEmpID,'9999') || ' - ' || vEname || to_char(vSalary,'$9999'));                       
       FETCH c_mycursor INTO vEname,vEmpID,vSalary;

   END LOOP;
      
   CLOSE c_mycursor;
 
  
EXCEPTION

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error detected: ' || SQLERRM);
END;
 