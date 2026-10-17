/* ============================================================
   10-cte-vs-temp-table.sql
   ============================================================
   A CTE is just a name for a query: SQL Server does NOT store
   its result. If you reference the same CTE twice, the
   underlying query is effectively expanded twice. A temp table
   stores the result once, can be indexed, and has statistics.

   Both queries below answer the same question -- "which pairs of
   departments have a higher average salary in the first than in
   the second?" -- and return identical rows. Run them with
   Actual Execution Plan on (Ctrl+M) and, ideally, SET STATISTICS
   IO ON, and compare how many times Employees is read.
   The data here is tiny, so the SIZE of the difference is not
   visible; the STRUCTURE of the two plans is.
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #DeptStats;
GO

-- Version A: CTE referenced twice (the aggregate is computed twice)
WITH DeptStats AS (
    SELECT DepartmentID, CAST(AVG(Salary) AS DECIMAL(10,2)) AS AvgSal
    FROM Employees
    GROUP BY DepartmentID
)

SELECT
    a.DepartmentID AS HigherDept,
    a.AvgSal       AS HigherAvg,
    b.DepartmentID AS LowerDept,
    b.AvgSal       AS LowerAvg
FROM DeptStats AS a
INNER JOIN DeptStats AS b ON b.DepartmentID <> a.DepartmentID
WHERE a.AvgSal > b.AvgSal
ORDER BY a.DepartmentID, b.DepartmentID;

-- Version B: aggregate computed ONCE into a temp table
SELECT DepartmentID, CAST(AVG(Salary) AS DECIMAL(10,2)) AS AvgSal
INTO #DeptStats
FROM Employees
GROUP BY DepartmentID;

SELECT
    a.DepartmentID AS HigherDept,
    a.AvgSal       AS HigherAvg,
    b.DepartmentID AS LowerDept,
    b.AvgSal       AS LowerAvg
FROM #DeptStats AS a
INNER JOIN #DeptStats AS b ON b.DepartmentID <> a.DepartmentID
WHERE a.AvgSal > b.AvgSal
ORDER BY a.DepartmentID, b.DepartmentID;

DROP TABLE #DeptStats;

-- ------------------------------------------------------------
-- Expected result (BOTH queries return the same 3 rows):
--     1 | 91000.00 | 2 | 77666.67
--     1 | 91000.00 | 3 | 73500.00
--     2 | 77666.67 | 3 | 73500.00
--
-- What to look for in the plans: Version A scans/aggregates
--   Employees once per CTE reference; Version B has a separate
--   first statement that reads Employees once, and the join then
--   reads only the small temp table. A CTE is not "worse" -- for a
--   single reference it is usually the cleaner choice. Reach for a
--   temp table when the same intermediate result is used several
--   times, is expensive to compute, or needs an index.
-- ------------------------------------------------------------