/* ============================================================
   12-indexed-view-count-big-rule.sql
   ============================================================
   One strict indexed-view rule for aggregate views:
   if the view uses GROUP BY, it must include COUNT_BIG(*).

   This file intentionally violates that rule to show the exact
   failure pattern, then cleans up the demo object.
   ============================================================ */

IF OBJECT_ID('dbo.vw_DepartmentSalaryTotals_NoCountBig', 'V') IS NOT NULL
    DROP VIEW dbo.vw_DepartmentSalaryTotals_NoCountBig;
GO

CREATE VIEW dbo.vw_DepartmentSalaryTotals_NoCountBig
WITH SCHEMABINDING
AS
SELECT
    e.DepartmentID,
    SUM(CONVERT(DECIMAL(19,2), e.Salary)) AS TotalSalary
FROM dbo.Employees AS e
WHERE e.DepartmentID IS NOT NULL
GROUP BY e.DepartmentID;
GO

BEGIN TRY
    CREATE UNIQUE CLUSTERED INDEX IX_vw_DepartmentSalaryTotals_NoCountBig_DepartmentID
    ON dbo.vw_DepartmentSalaryTotals_NoCountBig (DepartmentID);
    PRINT 'Unexpected: index creation succeeded.';
END TRY
BEGIN CATCH
    PRINT 'Expected failure: ' + ERROR_MESSAGE();
END CATCH;
GO

DROP VIEW dbo.vw_DepartmentSalaryTotals_NoCountBig;
GO

-- ------------------------------------------------------------
-- Expected result: CREATE INDEX fails with an error explaining
--   that COUNT_BIG is required for indexed views containing
--   GROUP BY. The temporary demo view is then dropped.
-- ------------------------------------------------------------
