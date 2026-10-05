/* ============================================================
   09-indexed-view-foundation.sql
   ============================================================
   An indexed view is a view that has a UNIQUE CLUSTERED INDEX.
   That index materializes the view result physically on disk, so
   SQL Server can sometimes read pre-aggregated/pre-joined data
   instead of recomputing it every time.

   Foundation rules shown here:
     1) The view must be created WITH SCHEMABINDING.
     2) For aggregate indexed views, use COUNT_BIG(*), not COUNT(*).
     3) Required SET options must be in the correct state.
   ============================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET ARITHABORT ON;
SET NUMERIC_ROUNDABORT OFF;
GO

CREATE OR ALTER VIEW dbo.vw_DepartmentSalaryTotals
WITH SCHEMABINDING
AS
SELECT
    e.DepartmentID,
    COUNT_BIG(*) AS EmployeeCount,
    SUM(CONVERT(DECIMAL(19,2), e.Salary)) AS TotalSalary
FROM dbo.Employees AS e
WHERE e.DepartmentID IS NOT NULL
GROUP BY e.DepartmentID;
GO

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
ORDER BY DepartmentID;

-- ------------------------------------------------------------
-- Expected result: one row per department currently present in
--   Employees (DepartmentID 1, 2, 3), with EmployeeCount and
--   TotalSalary already aggregated at the view level.
--   At this point, the view is schemabound but NOT indexed yet.
-- ------------------------------------------------------------
