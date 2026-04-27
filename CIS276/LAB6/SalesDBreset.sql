/*
SalesDBreset
C##SALESDB at PCC on ORACLE 10g using SQL*Plus
Reinitialize the SalesDB with DROP/CREATE/INSERT statements
2011.02.03 Vicki Jonathan, Instructor
2011.04.28 no changes needed for SQL Developer
2016.01.15  Adapted to new environment in cisdbor - Alan
*/

-- --------------------------------------------------
-- Equivalent to student submission drop-salesdb.sql
-- --------------------------------------------------

DROP TABLE ORDERITEMS PURGE;  -- child dropped before parents
DROP TABLE ORDERS PURGE;
DROP TABLE INVENTORY PURGE;
DROP TABLE CUSTOMERS PURGE;
DROP TABLE SALESPERSONS PURGE;

-- ----------------------------------------------------
-- Equivalent to student submission create-salesdb.sql
-- with examples for PK constraint
-- ----------------------------------------------------

CREATE TABLE CUSTOMERS
 (
  Custid NUMBER(4) NOT NULL,
  Cname CHAR(25) NOT NULL,
  Credit CHAR(1) NOT NULL,
  CONSTRAINT CREDIT_ck CHECK (Credit IN ('A','a','B','b','C','c')),
  CONSTRAINT CUSTOMER_pk PRIMARY KEY (Custid)
 );
 -- PK at table level

CREATE TABLE SALESPERSONS
 (
  Empid NUMBER(4) NOT NULL PRIMARY KEY,
  Ename CHAR(15) NOT NULL,
  Rank NUMBER(2) DEFAULT 1 NOT NULL CHECK (Rank IN (1,2,3)),
  Salary DECIMAL (8,2) DEFAULT 1000.00 NOT NULL CHECK (Salary >= 1000.00)
 );
 --  PK constraint (not named) at column level 

CREATE TABLE INVENTORY
 (
  Partid NUMBER(4) NOT NULL, 
  Description CHAR(12) NOT NULL,
  Stockqty NUMBER(4) NOT NULL,
  Reorderpnt NUMBER(4),
  Price DECIMAL (8,2) NOT NULL
 );
-- PK added later 
 ALTER TABLE INVENTORY
   ADD CONSTRAINT INVENTORY_pk PRIMARY KEY (Partid);

CREATE TABLE ORDERS
 (
  Orderid NUMBER(4) NOT NULL,
     CONSTRAINT ORDERS_pk PRIMARY KEY(Orderid),
  Empid NUMBER(4) NOT NULL,
     CONSTRAINT ORDERS_SP_fk FOREIGN KEY(Empid) REFERENCES SALESPERSONS,
  Custid NUMBER(4) NOT NULL,
     CONSTRAINT ORDERS_CU_fk FOREIGN KEY(Custid) REFERENCES CUSTOMERS,
  Salesdate DATE DEFAULT SYSDATE NOT NULL
);
-- named PK at column level

CREATE TABLE ORDERITEMS
 (
  Orderid NUMBER(4) NOT NULL,
    CONSTRAINT ORDERITEMS_ORD_fk FOREIGN KEY(Orderid) REFERENCES ORDERS,
  Detail NUMBER(2) NOT NULL,
  Partid NUMBER(4) NOT NULL,
     CONSTRAINT ORDERITEMS_INV_fk FOREIGN KEY(Partid) REFERENCES INVENTORY,
  Qty NUMBER(6) NOT NULL,
  CONSTRAINT ORDERITEMS_ORD_pk PRIMARY KEY(Orderid, Detail)
 );
 -- named, compound PK at table level
 
 -- ---------------------------------------------------
 -- Equivalent to student submission index-salesdb.sql
 -- ---------------------------------------------------
 
CREATE INDEX CUSTOMERS_cname_idx       ON CUSTOMERS (cname ASC);
CREATE INDEX SALESPERSONS_ename_idx    ON SALESPERSONS (ename ASC);
CREATE INDEX ORDERS_salesdate_idx      ON ORDERS (salesdate ASC);
CREATE INDEX INVENTORY_description_idx ON INVENTORY (description ASC);

 -- --------------------------------------------------
 -- Equivalent to student submission load-salesdb.sql
 -- --------------------------------------------------
 
INSERT INTO CUSTOMERS 
	SELECT * FROM C##SALESDB.CUSTOMERS;
INSERT INTO SALESPERSONS 
	SELECT * FROM C##SALESDB.SALESPERSONS;
INSERT INTO ORDERS 
	SELECT * FROM C##SALESDB.ORDERS;
INSERT INTO INVENTORY 
	SELECT * FROM C##SALESDB.INVENTORY;
INSERT INTO ORDERITEMS 
	SELECT * FROM C##SALESDB.ORDERITEMS;  -- child filled after parent(s)
	
COMMIT
/
