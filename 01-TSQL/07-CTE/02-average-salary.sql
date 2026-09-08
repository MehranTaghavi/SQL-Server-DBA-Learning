/* ============================================================
   Exercise 01 - Simple CTE: employees above company average salary
   ============================================================ */

WITH AvgSalaryCTE AS
(
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employees AS e
CROSS JOIN AvgSalaryCTE AS a
WHERE e.Salary > a.AvgSalary
ORDER BY e.Salary DESC;
