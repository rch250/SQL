/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [11/15/2015]

*******************************************************************************************
*/

USE FiredUp    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 8, Question 1  [3pts possible]:
Show the customer ID number, name, and email address for all customers; order the list by ID number.  You will 
need to join the CUSTOMER table with the EMAIL table to do this (either implicit or explicit syntax is ok); 
include duplicates for customers with multiple email accounts.  Format all output using CAST, CONVERT and/or STR ' + CHAR(10)
--
   SELECT STR(CustomerID,3) AS "Cust ID", 
          CAST(Name AS CHAR(25)) AS "Customer Name", 
		  CAST(EmailAddress AS CHAR(20)) AS "Email Address"
   FROM CUSTOMER AS C LEFT OUTER JOIN EMAIL AS E 
                      ON C.CustomerID = E.FK_CustomerID
   ORDER BY CustomerID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 2  [3pts possible]:
Which stoves have been sold?  Project serial number, type, version, and color from the STOVE table; join with the 
INV_LINE_ITEM table to identify the stoves which have been sold.  Concatenate type and version to a single column 
with this format: "Firedup v.1".  Eliminate duplicate lines.  List in order by serial number, and format all output.' + CHAR(10)
--
SELECT DISTINCT STR(ILI.FK_StoveNbr,3) AS "Serial No.",
       CAST(LTRIM(Type) + ' ' + Version AS CHAR(20)) AS "Type/Version", 
		  CAST(S.Color AS CHAR(8)) AS "Color"
   FROM INV_LINE_ITEM AS ILI, 
        STOVE AS S
   WHERE FK_StoveNbr IS NOT NULL
         AND ILI.FK_StoveNbr = S.SerialNumber
   ORDER BY "Serial No.";

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 3  [3pts possible]:
For every invoice, show the invoice number, the name of the customer, and the name of the employee.  You will need to
join the INVOICE table with EMPLOYEE and CUSTOMER using the appropriate join conditions.  Show the results in ascending
order of invoice number.' + CHAR(10)
--
SELECT STR(I.InvoiceNbr,3) AS "Invoice No.", 
       CAST(C.Name AS CHAR(20)) AS "Customer Name", 
	   CAST(E.Name AS CHAR(20)) AS "Employee Name"
FROM INVOICE AS I,
     CUSTOMER AS C,
	 EMPLOYEE AS E
WHERE     I.FK_CustomerID = C.CustomerID
      AND I.FK_EmpID = E.EmpID
ORDER BY I.InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 4  [3pts possible]:
List all stove repairs; show the repair number, description, and the total cost of the repair.  You will need to 
join with the REPAIR_LINE_ITEM TABLE and add up the values of ExtendedPrice using SUM. ' + CHAR(10)
--
SELECT STR(SR.RepairNbr,5) AS "Repair No.", 
       CAST(SR.Description AS CHAR(20)) AS "Description", 
	   '$' + STR(SUM(RLI.ExtendedPrice),5,2) AS "Cost"
FROM STOVE_REPAIR AS SR, 
     REPAIR_LINE_ITEM AS RLI
WHERE SR.RepairNbr = FK_RepairNbr
GROUP BY SR.RepairNbr, SR.Description;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 5  [3pts possible]:
Show the name of every employee along with the total number of stove repairs performed by them
(this may be zero - be sure to show every employee!).  You will need to perform an outer join on
EMPLOYEE and STOVE_REPAIR.  Sort the results in descending order by the number of repairs.' + CHAR(10)
--
SELECT CAST(E.Name AS CHAR(15)) AS "Employee Name", 
       STR(COUNT(SR.RepairNbr),3) AS "Repair Count"
FROM EMPLOYEE AS E LEFT OUTER JOIN STOVE_REPAIR AS SR
     ON E.EmpID = SR.FK_EmpID
GROUP BY E.Name
ORDER BY COUNT(SR.RepairNbr) DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 6  [3pts possible]:
Which sales were made in May of 2002? Display the invoice number, invoice date, and stove number (if any).
Use BETWEEN to specify the date range and list in chronological order by invoice date.' + CHAR(10)
--
SELECT STR(I.InvoiceNbr,3) AS "Invoice No.", 
       CONVERT(CHAR(10),I.InvoiceDt,101) AS "Date",
	   STR(ILI.FK_StoveNbr,3) AS "Stove No."
FROM   INVOICE AS I,
       INV_LINE_ITEM AS ILI
WHERE      I.InvoiceNbr = ILI.FK_InvoiceNbr
       AND I.InvoiceDt BETWEEN '05/01/2002' AND '05/31/2002'
ORDER BY I.InvoiceDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 7  [3pts possible]:
Show a list of all states from the CUSTOMER table; for each, display the state, the total 
number of customers in that state, and the total number of suppliers there.  Include all
states from CUSTOMER even if they have no suppliers.  Order results by state.' + CHAR(10)
--
SELECT CAST(C.StateProvince AS CHAR(3)) AS "StateProvince", 
       STR(Count(DISTINCT C.CustomerID),2) AS "Customer Count",
	   STR(Count(DISTINCT S.SupplierNbr),2) AS "Supplier Count"
FROM CUSTOMER AS C LEFT outer JOIN SUPPLIER AS S
     ON  C.StateProvince = S.State
GROUP BY StateProvince
ORDER BY StateProvince;


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 8  [3pts possible]:
Display a list of all stove repairs; for each, show the customer name, address, city/state/zip code (concatenated 
these last three into a single readable column), the repair date, and a description of the repair.  Order by 
repair date, and format all output.  Use an alias for the table names, and apply the alias to the beginning of 
the columns projected; e.g.:

SELECT t.COLUMN1
FROM   TABLENAME AS t
WHERE  t.COLUMN2 = 10;' + CHAR(10)
--
SELECT CAST(C.Name AS CHAR(20)) AS "Customer Name",
       CAST(C.StreetAddress AS CHAR(20)) AS "Street Address",
	   CAST(C.City + ', ' + C.StateProvince + ' ' + C.ZipCode AS CHAR(20)) AS CityStateZip,
	   CONVERT(CHAR(15),SR.RepairDt,101) AS "Repair Date",
	   CAST(SR.Description AS CHAR(20)) AS "Description"
FROM   CUSTOMER AS C,
       STOVE_REPAIR AS SR
WHERE  C.CustomerID = SR.FK_CustomerID
ORDER  BY SR.RepairDt;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 9  [3pts possible]:
Show a list of each supplier, along with a cash total of the extended price for all of their purchase orders. 
Display the supplier name and price total; sort alphabetically by supplier name and show the total in money 
format (i.e. $ and two decimal places ); rename the columns using AS.  Hint: you will need to join three tables,
use GROUP BY, and SUM(). ' + CHAR(10)
--
SELECT CAST(S.Name AS CHAR(20)) AS "Customer Name",
       '$' + STR(SUM(POLI.ExtendedPrice),7,2) AS "Total Price"
FROM SUPPLIER AS S,
     PURCHASE_ORDER AS PO,
	 PO_LINE_ITEM AS POLI
WHERE     S.SupplierNbr  = PO.FK_SupplierNbr
      AND PO.PONbr = POLI.FK_PONbr
GROUP BY S.Name
ORDER BY S.Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 10  [3pts possible]:
For each invoice, show the total cost of all parts; this is calculated by multiplying the invoice Quantity by the 
Cost for the part.   Show the invoice number and total cost (one line per invoice!).  Format all output (show 
money appropriately).' + CHAR(10)
--
SELECT STR(ILI.FK_InvoiceNbr,3) AS "Invoice No.", 
       '$' + STR(SUM(ILI.Quantity * P.Cost),7,2) AS "Total Cost"
FROM INV_LINE_ITEM AS ILI,
     PART AS P
WHERE ILI.FK_PartNbr = P.PartNbr
GROUP BY ILI.FK_InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 11  [3pts possible]:
Show the customer id, name, and the total of invoice extended price values for all customers who live in Oregon 
(exclude all others!).  Your output should include only one line for each customer.  Sort by customer ID.' + CHAR(10)
--
SELECT STR(C.CustomerID,3) AS "Customer ID",
       CAST(C.Name AS CHAR(15)) AS "Customer Name",
	   '$' + STR(SUM(ILI.ExtendedPrice),7,2) AS "Total"
FROM Customer AS C,
     INVOICE AS I,
     INV_LINE_ITEM AS ILI
WHERE     C.CustomerID = I.FK_CustomerID
     AND  ILI.FK_InvoiceNbr = I.InvoiceNbr
	 AND  C.StateProvince = 'OR'
GROUP BY C.CustomerID,
         C.Name
ORDER BY C.CustomerID;


--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 12  [3pts possible]:
For every invoice, display the invoice number, customer name, phone number, and email address.  Include duplicates 
where more than one email address or phone number exists.  List in order of customer name; format all output.' + CHAR(10)
--
SELECT STR(I.InvoiceNbr,3) AS "Invoice No.",
       CAST(C.Name AS CHAR(25)) AS "Customer Name",
	   CAST(P.PhoneNbr AS CHAR(15)) AS "Phone",
	   CAST(E.EmailAddress AS CHAR(20)) AS "Email Address"
FROM INVOICE AS I,
     CUSTOMER AS C,
	 PHONE AS P,
	 EMAIL AS E
WHERE     I.FK_CustomerID = C.CustomerID
      AND P.FK_CustomerID = C.CustomerID
	  AND E.FK_CustomerID = C.CustomerID
ORDER BY C.Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 13  [3pts possible]:
For every stove repair, display the stove serial number, Type and Version, the Cost of the repair, the Price of the
stove, and the percentage of the Price which the repair actually cost (i.e. Cost divided by Price).  Try to display
this last value as a whole number with a percentage sign (%).' + CHAR(10)
--
SELECT STR(SR.FK_StoveNbr,3) AS "Stove No.",
       CAST(S.Type AS CHAR(15)) AS "Type", 
	   STR(S.Version,5) AS "Version", 
	   '$' + STR(SR.Cost,5,2) AS "Repair",
	   '$' + STR(ST.Price,3) AS "Price",
	   STR((SR.Cost/ST.Price)*100,8) AS "Price/Repair %"
FROM STOVE_REPAIR AS SR,
     STOVE_TYPE AS ST,
	 STOVE AS S
WHERE SR.FK_StoveNbr = S.SerialNumber
      AND ST.Type = S.Type;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 14  [3pts possible]:
For every part, display the part number, description, the total number of repairs involving this part, the total
Quantity of the part for those repairs (use SUM), the total number of invoices involving this part, and the total
Quantity of the part for those invoices.  Use OUTER JOINs to display information for all parts, even if they are not
involved with any repairs or invoices.  You can solve this using only three tables (but be sure to avoid duplicates in
your counts!)...  Sort the output by part number.' + CHAR(10)
--
SELECT STR(P.PartNbr,3) AS "Part No.",
       CAST(P.Description AS CHAR(20)) AS "Description",
	   STR(COUNT(RLI.FK_PartNbr),3) AS "Repair Count",
	   SUM(RLI.Quantity) AS "Total Quantity",
	   COUNT(ILI.FK_PartNbr) AS "Total Invoices",
	   SUM(ILI.Quantity) AS "Quantity"
FROM   PART AS P LEFT OUTER JOIN REPAIR_LINE_ITEM AS RLI
            ON  P.PartNbr = RLI.FK_PartNbr
		    JOIN INV_LINE_ITEM AS ILI
		    ON P.PartNbr = ILI.FK_PartNbr
GROUP  BY  P.PartNbr,
       P.Description
ORDER BY P.PartNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 15  [3pts possible]:
Which invoices have involved parts whose name contains the words "widget" or "whatsit" (anywhere within the 
string)?  Display the invoice number and invoice date; sort output by invoice number.' + CHAR(10)
--
SELECT STR(I.InvoiceNbr,3) AS "Invoice No.", 
       CONVERT(CHAR(15),I.InvoiceDt,101) AS "Invoice Date"
FROM INVOICE AS I,
     INV_LINE_ITEM AS ILI,
	 PART AS P
WHERE I.InvoiceNbr = ILI.FK_InvoiceNbr
      AND P.PartNbr = ILI.FK_PartNbr
	  AND (UPPER(P.Description) LIKE '%WIDGET%' OR
	       UPPER(P.Description) LIKE '%WHATSIT%')
ORDER BY I.InvoiceNbr;	

--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


