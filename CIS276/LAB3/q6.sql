select partid,
       description,
       LPAD(TO_CHAR(PRICE,'$99.99'),8) "   PRICE"
from INVENTORY
where price between 1 AND 15
order by PRICE DESC;