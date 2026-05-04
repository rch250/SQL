-- CUSTID, ORDERID, PARTID, QTY
@SalesDBReset
@LAB6  1 6099 1001 15  --correct
@LAB6  -1 6099 1001 15 -- invalid customer
@LAB6  1 -1    1001 15 -- invalid orderid
@LAB6  2 6099  1001 15 -- invalid custid and orderid
@LAB6  1 6099 -1 15    -- invalid partid
@LAB6  1 6099 1001 -1  -- invalid qty
@LAB6  1 6099 1001 200 -- invalid stock qty
