/* ============================================================
   10-create-indexed-view.sql
   ============================================================
   Run 09-indexed-view-foundation.sql first.

   This file creates the FIRST index on the view (must be UNIQUE
   CLUSTERED). That is the exact moment a normal view becomes an
   indexed view (materialized view) in SQL Server.
   ============================================================ */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.vw_DepartmentSalaryTotals')
      AND name = 'IX_vw_DepartmentSalaryTotals_DepartmentID'
)
    DROP INDEX IX_vw_DepartmentSalaryTotals_DepartmentID
    ON dbo.vw_DepartmentSalaryTotals;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_DepartmentSalaryTotals_DepartmentID
ON dbo.vw_DepartmentSalaryTotals (DepartmentID);
GO

SELECT
    i.name,
    i.type_desc,
    i.is_unique,
    i.is_primary_key
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('dbo.vw_DepartmentSalaryTotals');

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
ORDER BY DepartmentID;

-- ------------------------------------------------------------
-- Expected result: the index list now includes
--   IX_vw_DepartmentSalaryTotals_DepartmentID as UNIQUE CLUSTERED.
--   This confirms the view is now physically indexed/materialized.
-- ------------------------------------------------------------
