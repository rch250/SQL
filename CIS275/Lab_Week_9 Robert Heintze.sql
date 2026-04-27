/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 9: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Robert Heintze]
                DATE:      [11/22/2015]

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
PRINT 'CIS2275, Lab Week 9, Question 1  [3pts possible]:
Show the serial numbers of all the "FiredAlways" stoves which have been invoiced.  Use whichever method you prefer 
(a join or a subquery).  List in order of serial number and eliminate duplicates.' + CHAR(10)
--

SELECT DISTINCT STR(FK_StoveNbr,3) AS "Serial No."
FROM INV_LINE_ITEM
WHERE FK_StoveNbr IS NOT NULL
   AND FK_StoveNbr IN
   (SELECT SerialNumber
    FROM STOVE
	WHERE Stove.Type = 'FiredAlways')
ORDER BY "Serial No.";

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 2  [3pts possible]:
Show the name and email address of all customers who have ever brought a stove in for repair (include duplicates and 
ignore customers without email addresses). ' + CHAR(10)
--
  SELECT CAST(C.Name AS CHAR(25)) AS "Customer Name", 
         CAST(E.EmailAddress AS CHAR(30)) AS "Email Address"
  FROM CUSTOMER AS C, 
       EMAIL AS E,
       STOVE_REPAIR AS SR 
  WHERE C.CustomerID = E.FK_CustomerID
  AND   C.CustomerID = SR.FK_CustomerID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 3  [3pts possible]:
What stoves have been sold to customers with the last name of "Smith"?  Display the customer name, stove number, stove 
type, and stove version and show the results in customer name order.' + CHAR(10)
--
SELECT CAST(C.Name AS CHAR(15)) AS "Customer Name", 
       STR(S.SerialNumber,3) AS "Stove No.", 
	   CAST(LTRIM(Type) + ' ' + Version AS CHAR(20)) AS "Type/Version"
FROM CUSTOMER AS C, 
     STOVE AS S, 
	 INVOICE AS I, 
	 INV_LINE_ITEM AS ILI
WHERE C.CustomerID = I.FK_CustomerID
 AND  I.InvoiceNbr = ILI.FK_InvoiceNbr
 AND  S.SerialNumber = ILI.FK_StoveNbr
 AND  UPPER(C.Name) LIKE '%SMITH'
ORDER BY C.Name;



--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 4  [3pts possible]:
What employee has sold the most stoves in the most popular state?  ("most popular state" means the state or states for 
customers who purchased the most stoves, regardless of the stove type and version; do not hardcode a specific state 
into your query)  Display the employee number, employee name, the name of the most popular state, and the number of 
stoves sold by the employee in that state.  If there is more than one employee then display them all.' + CHAR(10)
--
    SELECT TOP 1 STR(E.EmpID,3) AS "Employee No.", 
	       CAST(E.Name AS CHAR(15)) AS "Employee Name", 
		   CAST(C.StateProvince AS CHAR(3)) AS "State",
		   STR(SUM(ILI.QUANTITY),3) AS "Total Stoves Sold"
	FROM CUSTOMER AS C,
	     EMPLOYEE AS E, 
	     INVOICE AS I, 
		 INV_LINE_ITEM AS ILI
	WHERE C.CustomerID = I.FK_CustomerID
	AND   E.EmpID = I.FK_EmpID
	AND   I.InvoiceNbr = ILI.FK_InvoiceNbr
    AND   ILI.FK_StoveNbr IS NOT NULL
	AND C.StateProvince IN (
		SELECT TOP 1 StateProvince--, COUNT(*)
		FROM CUSTOMER AS C,
			 INVOICE AS I,
			 INV_LINE_ITEM AS ILI
		WHERE C.CustomerID = I.FK_CustomerID
		AND   I.InvoiceNbr = ILI.FK_InvoiceNbr
		AND   ILI.FK_StoveNbr IS NOT NULL
		GROUP BY C.StateProvince
		ORDER BY COUNT(ILI.Fk_StoveNbr) DESC
)
GROUP BY E.EmpID, E.Name, C.StateProvince
ORDER BY SUM(ILI.QUANTITY) DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 5  [3pts possible]:
Identify all the sales associates who have ever sold the FiredAlways version 1 stove; show a breakdown of the total 
number sold by color.  i.e. for each line, show the employee name, the stove color, and the total number sold.  Sort 
the results by name, then color.' + CHAR(10)
--
   SELECT CAST(E.Name AS CHAR(15)) AS "Employee Name",
          CAST(S.Color AS CHAR(10)) AS "Color", 
		  STR(SUM(ILI.QUANTITY),3) AS "Total Stoves Sold"
   FROM EMPLOYEE AS E, 
        STOVE AS S,
		INVOICE AS I, 
		INV_LINE_ITEM AS ILI
   WHERE E.EmpID = I.FK_EmpID
	AND   I.InvoiceNbr = ILI.FK_InvoiceNbr
    AND   ILI.FK_StoveNbr = S.SerialNumber
	AND   S.Type = 'FiredAlways'
	AND   S.Version = 1
   GROUP BY E.Name, S.Color
   ORDER BY E.Name, S.Color;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 6  [3pts possible]:
Show the name and phone number for all customers who have a Hotmail address (i.e. an entry in the EMAIL table which 
ends in hotmail.com).  Include duplicate names where multiple phone numbers exist; sort results by customer name.' + CHAR(10)
--
SELECT CAST(C.Name AS CHAR(15)) AS "Customer Name",
       CAST(P.PhoneNbr AS CHAR(12)) AS "Phone No."
	 --  E.EmailAddress
FROM CUSTOMER AS C, 
     PHONE AS P, 
	 EMAIL AS E
WHERE C.CustomerID = P.FK_CustomerID
  AND C.CustomerID = E.FK_CustomerID
  AND E.EmailAddress LIKE '%hotmail%';
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 7  [3pts possible]:
Show the purchase order number, average SalesPrice, and average ExtendedPrice for parts priced between $1 and $2 which 
were ordered from suppliers in Virginia.  List in descending order of average ExtendedPrice.  Format all output. ' + CHAR(10)
--
  SELECT STR(POLI.FK_PONbr,3) AS "PO No.", 
  	     '$' + STR(AVG(P.SalesPrice),5,2) AS "Sales Price",
         '$' + STR(AVG(POLI.ExtendedPrice),7,2) AS "Extended Price"
  FROM PO_LINE_ITEM AS POLI,
       PART AS P,
	   SUPPLIER AS S,
	   PURCHASE_ORDER AS PO
  WHERE     POLI.FK_PartNbr = P.PartNbr
        AND S.SupplierNbr = PO.FK_SupplierNbr
		AND P.PartNbr = POLI.FK_PartNbr
		AND P.SalesPrice BETWEEN 1 AND 2
		AND S.State = 'VA'
  GROUP BY POLI.FK_PONbr
  ORDER BY AVG(POLI.ExtendedPrice) DESC;


        

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 8  [3pts possible]:
Which invoice has the second-lowest total price among invoices that do not include a sale of a FiredAlways stove? 
Display the invoice number, invoice date, and invoice total price.  If there is more than one invoice then display all 
of them. (Note: finding invoices that do not include a FiredAlways stove is NOT the same as finding invoices where a 
line item contains something other than a FiredAlways stove -- invoices have more than one line.  Avoid a JOIN with the 
STOVE since the lowest price may not involve any stove sales.)' + CHAR(10)
--
   SELECT TOP 1 WITH TIES *
   FROM (
   SELECT TOP 2 WITH TIES 
          STR(I.InvoiceNbr,3) AS "Invoice No.", 
          CONVERT(CHAR(10),I.InvoiceDt,101) AS "Invoice Date",
		  '$' + STR(I.TotalPrice,5,2) AS "Total Price"
   FROM INVOICE AS I,
        INV_LINE_ITEM AS ILI,
		STOVE AS S
   WHERE  I.InvoiceNbr = ILI.FK_InvoiceNbr
    AND   ILI.FK_StoveNbr IN
	(SELECT SerialNumber
	 FROM STOVE
	 WHERE Type <> 'FiredAlways')
  GROUP BY I.InvoiceNbr,I.InvoiceDt,I.TotalPrice
  ORDER BY I.TotalPrice ASC
  ) AS TEST
  ORDER BY 3 DESC;
  
	  
        
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 9  [3pts possible]:
What employee(s) have sold the most stoves in the least popular color ("least popular color" means the color that has 
been purchased the least number of times, regardless of the stove type and version. Do not hardcode a specific color 
into your query)?  If there is more than one employee tied for the most then display them all.  If there is a tie for 
"least popular color" then you may pick ANY of them.  Display the employee name, number of stoves sold, and the least 
popular color.' + CHAR(10)
--
SELECT TOP 1 WITH TIES *
	FROM (
		SELECT CAST(E.Name AS CHAR(15)) AS "Employee Name",
			   STR(SUM(ILI.Quantity),3) AS "Total", 
			   CAST(S.Color AS CHAR(10)) AS "Color"
		 FROM INV_LINE_ITEM AS ILI,
			  INVOICE AS I,
			  EMPLOYEE AS E,
			  STOVE AS S
		WHERE E.EmpID = I.FK_EmpID  
		  AND I.InvoiceNbr = ILI.FK_InvoiceNbr
		  AND ILI.FK_StoveNbr = S.SerialNumber
		  AND S.Color IN
			 (SELECT TOP 1 S.Color
			  FROM  INV_LINE_ITEM AS ILI,
					STOVE AS S
			  WHERE ILI.FK_StoveNbr = S.SerialNumber
			  GROUP BY S.Color
			  ORDER BY SUM(ILI.Quantity) 
			  )
		GROUP BY E.Name, S.Color
--		ORDER BY SUM(ILI.Quantity) DESC
		) AS TEST
	ORDER BY 2 DESC;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 10  [3pts possible]:
Show a breakdown of all part entries in invoices.  For each invoice, show the customer name, invoice number, the number 
of invoice lines for parts (exclude stoves!), the total number of parts for the invoice (add up Quantity), and the total 
ExtendedPrice values for these parts.  Format all output; sort by customer name, then invoice number. ' + CHAR(10)
--
SELECT CAST(C.Name AS CHAR(15)) AS "Customer Name", 
       STR(I.InvoiceNbr,4) AS "Invoice No.",
	   STR(COUNT(ILI.LineNbr),4) AS "T. Line No.", 
	   STR(SUM(ILI.Quantity),3) AS "T. Qty",
	   '$' + STR(SUM(ILI.ExtendedPrice),7,2) AS "T. ExtendedPrice"
FROM PART AS P,
     INVOICE AS I,
	 CUSTOMER AS C,
     INV_LINE_ITEM AS ILI
WHERE   C.CustomerID = I.FK_CustomerID
   AND  I.InvoiceNbr = ILI.FK_InvoiceNbr
   AND  ILI.FK_StoveNbr IS NULL
GROUP BY C.Name, I.InvoiceNbr
ORDER BY C.Name, I.InvoiceNbr;
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 9' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


