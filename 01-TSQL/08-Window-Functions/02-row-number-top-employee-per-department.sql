/* ============================================================
   Exercise 02 - ROW_NUMBER + PARTITION BY: highest-paid
   employee in each department
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Find the single highest-paid employee within every
   department using ROW_NUMBER() with PARTITION BY.
   ============================================================ */

WITH RankedEmployees AS
(
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        d.DepartmentName,
        e.Salary,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.Salary DESC) AS rn
    FROM Employees AS e
    INNER JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
)
SELECT EmployeeID, FirstName, LastName, DepartmentName, Salary
FROM RankedEmployees
WHERE rn = 1
ORDER BY DepartmentName;