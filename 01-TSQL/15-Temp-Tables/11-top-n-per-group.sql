/* ============================================================
   11-top-n-per-group.sql
   ============================================================
   Advanced pattern: rank rows inside each group with
   ROW_NUMBER(), store the ranked set in a temp table, add an
   index, then filter and join. Here: the top 2 earners in every
   department.
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #Ranked;
GO

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS RankInDept
INTO #Ranked
FROM Employees;

-- Index the column the next step filters and joins on:
CREATE CLUSTERED INDEX IX_Ranked_Dept ON #Ranked (DepartmentID, RankInDept);

SELECT
    d.DepartmentName,
    r.RankInDept,
    r.FirstName,
    r.LastName,
    r.Salary
FROM #Ranked AS r
INNER JOIN Departments AS d ON d.DepartmentID = r.DepartmentID
WHERE r.RankInDept <= 2
ORDER BY d.DepartmentName, r.RankInDept;

DROP TABLE #Ranked;

-- ------------------------------------------------------------
-- Expected result: 6 rows (2 per department, departments in
--   alphabetical order):
--     HR    | 1 | Sara    Nouri   75000.00
--     HR    | 2 | Hossein Razavi  72000.00
--     IT    | 1 | Mina    Jafari  95000.00
--     IT    | 2 | Ali     Ahmadi  90000.00
--     Sales | 1 | Reza    Kamali  85000.00
--     Sales | 2 | Neda    Sadeghi 78000.00
-- ------------------------------------------------------------