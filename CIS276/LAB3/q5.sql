select ename, 
       TO_CHAR(S.SALARY,'$9999') "Salary"
FROM SALESPERSONS S
where S.salary <= 2500
order by salary DESC;