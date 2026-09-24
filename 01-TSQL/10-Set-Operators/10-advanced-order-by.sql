/* ============================================================
   Exercise 10 - ORDER BY Rules: Sort the final combined 
                 result set across multiple queries
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees_HQ

UNION ALL

SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees_Branch

ORDER BY Salary DESC, LastName ASC;
