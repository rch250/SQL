SELECT I.PartID, 
       I.Description, 
       LPAD(TO_CHAR(PRICE,'$99.99'),8) "   PRICE"
FROM INVENTORY I
WHERE (I.Price = 
   (SELECT MAX(INVENTORY.Price) AS Price FROM INVENTORY)) 
   OR 
   I.Price = 
   (SELECT MIN(INVENTORY.Price) AS Price
FROM INVENTORY);
