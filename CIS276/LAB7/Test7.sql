-- CUSTID, ORDERID, PARTID, QTY
@SalesDBReset
@LAB7  1 6099 1001 15  --correct
@LAB7  -1 6099 1001 15 -- invalid customer
@LAB7  1 -1    1001 15 -- invalid orderid
@LAB7  2 6099  1001 15 -- invalid custid and orderid
@LAB7  1 6099 -1 15    -- invalid partid
@LAB7  1 6099 1001 -1  -- invalid qty
@LAB7  1 6099 1001 200 -- invalid stock qty
