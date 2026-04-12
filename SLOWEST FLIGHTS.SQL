SELECT round(avg(f.arr_delay).0) as avg_delay, a.name
FROM flights AS f
INNER JOIN airlines AS a ON f.carrier = a.carrier
GROUP BY a.name
ORDER BY avg_delay DESC;