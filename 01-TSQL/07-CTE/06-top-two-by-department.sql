/* ============================================================
   Exercise 05 - CTE with ROW_NUMBER: top two earners per department
   ============================================================ */

WITH RankedEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RowNum
    FROM Employees
)
SELECT r.FirstName, r.LastName, d.DepartmentName, r.Salary, r.RowNum
FROM RankedEmployees AS r
JOIN Departments AS d ON d.DepartmentID = r.DepartmentID
WHERE r.RowNum <= 2
ORDER BY d.DepartmentName, r.RowNum;
