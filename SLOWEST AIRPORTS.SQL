SELECT round(avg(f.arr_delay),O) as avg_delay, a.name
FROM flights AS f
INNER JOIN airports AS a ON f.dest = a.faa
GROUP BY a.name
ORDER BY avg_delay DESC;