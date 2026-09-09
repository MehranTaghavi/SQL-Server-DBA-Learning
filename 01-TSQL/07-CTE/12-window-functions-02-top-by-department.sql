/* ============================================================
   Exercise 12 - Window functions: top employee in each department
   Practice PARTITION BY with ROW_NUMBER
   ============================================================ */

WITH RankedEmployees AS
(
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        d.DepartmentName,
        e.Salary,
        ROW_NUMBER() OVER (
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC, e.EmployeeID
        ) AS RowNum
    FROM Employees AS e
    JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentName,
    Salary
FROM RankedEmployees
WHERE RowNum = 1
ORDER BY DepartmentName;
