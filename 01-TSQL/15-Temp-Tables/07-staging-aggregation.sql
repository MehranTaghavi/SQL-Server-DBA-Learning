/* ============================================================
   07-staging-aggregation.sql
   ============================================================
   A very common use: compute an aggregate ONCE, park it in a
   temp table, then join back to it. Here: each department's
   average salary, then every employee earning above their own
   department's average.
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #DeptAvg;
GO

SELECT
    DepartmentID,
    CAST(AVG(Salary) AS DECIMAL(10,2)) AS AvgSalary
INTO #DeptAvg
FROM Employees
GROUP BY DepartmentID;

SELECT DepartmentID, AvgSalary FROM #DeptAvg ORDER BY DepartmentID;

SELECT
    e.FirstName,
    e.LastName,
    e.Salary,
    d.AvgSalary AS DeptAvgSalary
FROM Employees AS e
INNER JOIN #DeptAvg AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary
ORDER BY e.Salary DESC;

DROP TABLE #DeptAvg;

-- ------------------------------------------------------------
-- Expected result:
--   First SELECT (#DeptAvg): 1 | 91000.00, 2 | 77666.67, 3 | 73500.00
--   Second SELECT: 4 rows, highest salary first --
--     Mina  Jafari  95000.00  (IT average    91000.00)
--     Reza  Kamali  85000.00  (Sales average 77666.67)
--     Neda  Sadeghi 78000.00  (Sales average 77666.67)
--     Sara  Nouri   75000.00  (HR average    73500.00)
-- ------------------------------------------------------------
