/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 7: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [11-8-2015]

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
PRINT 'CIS2275, Lab Week 7, Question 1  [3pts possible]:
Show the invoice number and total price for all invoices which go to customers from Oregon.  Use an uncorrelated IN 
subquery to identify Oregon customers (you will not need to join any tables).  Format all output, and show in 
chronological order by invoice date. ' + CHAR(10)
--
SELECT STR(InvoiceNbr,3) AS "Invoice No.",
       '$' + STR(TotalPrice,7,2) AS "Total Price"
FROM INVOICE
WHERE FK_CustomerID IN
   (SELECT CustomerID
    FROM CUSTOMER
	WHERE StateProvince = 'OR'
	)
ORDER By InvoiceDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 2  [3pts possible]:
Display the serial number, manufacture date, and color for all FiredNow stoves which were not built by Mike Wentland. 
Do not assume that we know Mike''s employee number; use an uncorrelated NOT IN subquery to identify the correct 
employee (you will not need to join any tables).  Rename all columns, and format the date to MM/DD/YYYY.  Sort output 
in descending order by manufacture date.' + CHAR(10)
--
SELECT STR(SerialNumber, 4) AS "S/N",
       CONVERT(CHAR(10),DateofManufacture,101) AS "Mfg. Date",
	   CAST(Color AS CHAR(6)) AS "Color"
FROM STOVE
WHERE FK_EmpID NOT IN
	(
	SELECT EmpID
	FROM EMPLOYEE
	WHERE Name = 'Mike Wentland'
	) 
ORDER BY DateofManufacture DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 3  [3pts possible]:
Show the invoice number, part number, and quantity for all invoices lines which are for parts which have a Cost value 
less than $1.50.  Use a correlated IN subquery to identify the parts (the correlation is not necessary, but apply it
anyway).  Format all output, and show in descending order by Quantity.    ' + CHAR(10)
--
SELECT STR(FK_InvoiceNbr,4) AS "Invoice No.",
       STR(FK_PartNbr,4) AS "Part No." ,
	   STR(Quantity,3) AS "Quantity"
FROM INV_LINE_ITEM
WHERE (FK_PartNbr IS NOT NULL) AND 
  (FK_PartNbr IN
  (SELECT PartNbr
   FROM PART
   WHERE Cost < 1.5
   AND PartNbr = FK_PartNbr)
   )
 ORDER BY Quantity DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 4  [3pts possible]:
Which customers have not returned stoves for repair?  List the customer’s name only and show the results in customer 
name order (alphabetical, A-Z).  Use the SQL keyword EXISTS (or NOT EXISTS) and a correlated subquery. ' + CHAR(10)
--
SELECT CAST(Name AS CHAR(15)) AS "Customer Name"
FROM CUSTOMER
WHERE NOT EXISTS
  (SELECT * 
   FROM STOVE_REPAIR
   WHERE FK_CustomerID = CustomerID
  )
ORDER BY Name;
 

  
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 5  [3pts possible]:
Identify invoices which contain charges for more than one of the same part (i.e. the Quantity is greater than 1). 
Use a correlated EXISTS subquery to identify the correct entries.  For each invoice, display the invoice 
number, date, and total price.  Format all output; show date in YYYYMMDD format. ' + CHAR(10)
--
SELECT STR(InvoiceNbr,3) AS "Invoice No.",
       CONVERT(CHAR(10),InvoiceDt,112) AS "Invoice Date", 
	   '$' + STR(TotalPrice,7,2) AS "Total Price"
FROM INVOICE
WHERE EXISTS
  (SELECT *
   FROM INV_LINE_ITEM
   WHERE (Quantity > 1) 
         AND (FK_InvoiceNbr = InvoiceNbr)
   );

 
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 6  [3pts possible]:
Identify the type/version (from the STOVE_TYPE table) of the stove model which has the highest Price value. 
Use an = subquery to find the correct value (you will need to ensure that your subquery returns only one column and 
only one row!).  Display the type and version together in this format: "FiredNow v1" and label the concatenated 
column Type/version.' + CHAR(10)
--
SELECT CAST(Type AS CHAR(15)) AS "Type", 
       STR(Version,1) AS "Version"
FROM STOVE_TYPE
WHERE Price = (SELECT MAX(PRICE)
               FROM STOVE_TYPE);

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 7  [3pts possible]:
Show the invoice number, date, and total price for invoices which have been taken by ''Sales Associate'' employees, 
and which have sold to customers whose ZIP code begins with ''9''.  Format all output.  Use subqueries and no joins.' + CHAR(10)
--

SELECT STR(InvoiceNbr,3) AS "Invoice No.", 
       CONVERT(CHAR(15),InvoiceDt,101) AS "Invoice Date", 
	   '$' + STR(TotalPrice,7,2) AS "Total Price"
FROM INVOICE 
WHERE FK_CustomerID IN
  (SELECT CustomerID
   FROM CUSTOMER
   WHERE (ZipCode Like '9%') 
  )
  AND FK_EmpID IN
   (SELECT EmpID 
    FROM EMPLOYEE
	WHERE (Title = 'Sales Associate')
   );

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 8  [3pts possible]:
Show the customer ID number and name (format and rename columns) for all customers who have purchased a FiredNow 
version 1 stove.  Use only subqueries, and no joins.' + CHAR(10)
--

SELECT STR(CustomerID,3) AS "CustomerID", 
       CAST(Name as CHAR(20)) AS "Customer Name"
FROM CUSTOMER
WHERE CustomerID IN
	(SELECT FK_CustomerID 
	 FROM INVOICE
	 WHERE InvoiceNbr IN
		(SELECT FK_InvoiceNbr 
		 FROM INV_LINE_ITEM
		 WHERE FK_StoveNbr IN
			(SELECT SerialNumber
			 FROM Stove
			 WHERE (TYPE = 'FiredNow') AND (Version = 1)
			)
		)
	);

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 9  [3pts possible]:
Which stoves were sold to Oregon customers?  Display stove type and version of stoves involved in invoices for Oregon 
customers.  Eliminate duplicate values in your results.  Sort output on type and version.' + CHAR(10)
--
--SELECT DISTINCT CAST(RTRIM(Type) = ' ' + Version AS CHAR(13)) AS 'Oregon Stoves'
--SELECT DISTINCT CAST(Type + ' ' + Version AS CHAR(13)) AS 'Oregon Stoves'
SELECT DISTINCT Type AS 'Oregon Stoves', 
      STR(Version,3) AS "Version"
FROM STOVE
WHERE SerialNumber IN
   (SELECT FK_Stovenbr
	FROM INV_LINE_ITEM
	WHERE FK_Stovenbr IS NOT NULL
	AND FK_Invoicenbr IN
		(SELECT InvoiceNbr
			FROM INVOICE
			WHERE FK_CustomerID IN
				(SELECT CustomerID
				FROM CUSTOMER
				WHERE StateProvince = 'OR'
				)
		)
	)
ORDER BY Type, Version;
	--
	GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 10  [3pts possible]:
Show the repair number and description for every stove repair which either (belongs to a
customer from California or Washington) or (is blue in color).  Be careful to use parentheses
to apply the correct logic!
Note that the primary key of the STOVE table (Serialnumber) corresponds to the foreign key
FK_StoveNbr in STOVE_REPAIR.' + CHAR(10)
--
SELECT STR(RepairNbr,4) AS "Repair No.", 
       CAST(Description AS CHAR(5)) AS "Description"
FROM Stove_Repair
WHERE (FK_CustomerID IN
		  (SELECT CustomerID
		  FROM Customer
		  WHERE StateProvince IN ('CA','WA')
		  )
	  )
  OR
  (FK_StoveNbr IN 
	  (SELECT SerialNumber
	   FROM STOVE
	   WHERE Color = 'BLUE'
	  )
  );
  
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 11  [3pts possible]:
Which employee(s) has all but one of their invoices written after February 15, 2002?  (Hint: "all but one after" is the 
same as saying "only one was written on or before Feb 15") Make sure that the employee also has some Invoices written 
after February 15, 2002.  (Other hint: review the use of GROUP BY with HAVING)  Display the employee name(s).' + CHAR(10)
--
SELECT CAST(Name AS CHAR(15)) AS "Employee Name"
FROM EMPLOYEE 
WHERE (EmpID IN 
		  (SELECT FK_EmpID
		   FROM INVOICE
		   WHERE InvoiceDt < '20020215'
		   GROUP BY FK_EmpID
		   HAVING COUNT(InvoiceNbr) = 1
		   ) 
	  )
	  AND 
	  (EmpID IN 
		  (SELECT FK_EmpID
		   FROM INVOICE
		   WHERE InvoiceDt >= '20020215'
		   GROUP BY FK_EmpID
		   HAVING COUNT(InvoiceNbr) >= 1
		   ) 
	  );
 
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 12  [3pts possible]:
Show the name of the employee who has built the most expensive stove (i.e. the one with the highest price listed in 
STOVE_TYPE).  Use subqueries and no joins.' + CHAR(10)
--
SELECT CAST(Name AS CHAR(15)) AS "Employee Name"
FROM EMPLOYEE
WHERE EmpID IN
  (SELECT FK_EmpID
   FROM STOVE
   WHERE Type IN
     (SELECT Type
	 FROM Stove_Type
	 WHERE Price IN
	   (SELECT MAX(Price)
	    FROM Stove_Type
	   )
	 )
  );
     
	   
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 13  [3pts possible]:
Show the names of all customers who are on invoices which contain parts.  Use subqueries and no joins.' + CHAR(10)
--
SELECT CAST(Name AS CHAR(15)) AS "Name"
FROM CUSTOMER
WHERE CustomerID IN
  (SELECT FK_CustomerID
   FROM INVOICE
   WHERE InvoiceNbr IN
      (SELECT FK_InvoiceNbr
	  FROM INV_LINE_ITEM
	  WHERE FK_PartNbr IS NOT NULL)
  );

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 14  [3pts possible]:
Show the purchase order number and Terms from the PURCHASE_ORDER table where the corresponding supplier''s
RepPhoneNumber is in the 541 area code.  Use subqueries and no joins.' + CHAR(10)
--
SELECT CAST(PONbr AS CHAR(10)) AS "PO No.", 
       CAST(Terms AS CHAR(10)) AS "Terms"
FROM PURCHASE_ORDER
WHERE FK_SupplierNbr IN
  (SELECT SupplierNbr AS "SupplierNbr"
   FROM Supplier
   WHERE (RepPhoneNumber LIKE '541%')
   );
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 15  [3pts possible]:
Which stove models (combination of type and version) have NEVER been purchased by customers in California?
Display the stove type and stove version.  Hint: finding stoves never sold in CA is NOT the same as finding stoves
sold outside of CA; it''s easier to identify stoves which *have* sold in CA and filter them out via a subquery.' + CHAR(10)
--
SELECT CAST(Type AS CHAR(15)) AS "Type", 
       STR(Version,5) AS "Version"
FROM STOVE
WHERE SerialNumber IN
  (SELECT FK_StoveNbr
   FROM INV_LINE_ITEM
   WHERE (FK_StoveNbr IS NOT NULL) 
   AND (FK_InvoiceNbr IN
		(SELECT InvoiceNbr
			FROM INVOICE
			WHERE FK_CustomerID IN
			(SELECT CustomerID
			FROM Customer
			WHERE StateProvince NOT IN ('CA')
			)
		)
	   )
  )
GROUP BY Type,Version;
	 
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 7' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


