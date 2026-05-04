select partid,
       description 
from inventory
where upper(substr(description,1,1)) = 'T'
order by price asc;
