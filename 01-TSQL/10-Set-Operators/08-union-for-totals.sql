/* ============================================================
   Exercise 08 - Data Type Casting: Use UNION to append a 
                 grand total summary row at the bottom
   ============================================================ */

SELECT CAST(EmployeeID AS VARCHAR(10)) AS ID, FirstName, Salary
FROM Employees_HQ

UNION ALL

SELECT 'TOTAL', '---', SUM(Salary)
FROM Employees_HQ;
