/* ============================================================
   Exercise 02 - CTE with aggregation: departments with more than
                  two employees
   ============================================================ */

WITH DeptCountCTE AS
(
    SELECT DepartmentID, COUNT(*) AS EmployeeCount
    FROM Employees
    GROUP BY DepartmentID
)
SELECT d.DepartmentName, dc.EmployeeCount
FROM DeptCountCTE AS dc
JOIN Departments AS d ON d.DepartmentID = dc.DepartmentID
WHERE dc.EmployeeCount > 2
ORDER BY dc.EmployeeCount DESC;
