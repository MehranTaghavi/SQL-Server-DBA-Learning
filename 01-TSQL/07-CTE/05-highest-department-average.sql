/* ============================================================
   Exercise 04 - Chained CTEs: department with the highest
                  average salary
   ============================================================ */

WITH DeptAvgCTE AS
(
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
),
MaxAvgCTE AS
(
    SELECT MAX(AvgSalary) AS MaxAvg
    FROM DeptAvgCTE
)
SELECT d.DepartmentName, da.AvgSalary
FROM DeptAvgCTE AS da
JOIN Departments AS d ON d.DepartmentID = da.DepartmentID
JOIN MaxAvgCTE AS m ON da.AvgSalary = m.MaxAvg;
