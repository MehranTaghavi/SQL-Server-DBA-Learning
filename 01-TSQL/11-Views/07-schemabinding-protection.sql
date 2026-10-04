/* ============================================================
   07-schemabinding-protection.sql
   ============================================================
   Run 06-schemabinding-basic.sql first.

   Part A: try to drop a column the schemabound view DOES
   reference (Salary) -- this must be REJECTED.
   Part B: add a throwaway column the view does NOT reference,
   then drop it -- this must SUCCEED, because SQL Server tracks
   the dependency per COLUMN, not per table. The throwaway column
   is removed again at the end of this file, so re-running it
   leaves Employees exactly as 00-setup.sql created it.
   ============================================================ */

------------------------------------------------------------
-- Part A: this is expected to FAIL.
------------------------------------------------------------
BEGIN TRY
    ALTER TABLE dbo.Employees DROP COLUMN Salary;
    PRINT 'Unexpected: the DROP COLUMN succeeded.';
END TRY
BEGIN CATCH
    PRINT 'Expected failure: ' + ERROR_MESSAGE();
END CATCH;

------------------------------------------------------------
-- Part B: this is expected to SUCCEED, start to finish.
------------------------------------------------------------
ALTER TABLE dbo.Employees ADD Notes VARCHAR(200) NULL;

-- vw_EmployeeSalarySchemaBound never mentions Notes, so dropping
-- it is allowed even though the table is schemabound-referenced.
ALTER TABLE dbo.Employees DROP COLUMN Notes;

PRINT 'Notes column added and dropped successfully -- unaffected by SCHEMABINDING on Salary.';

-- ------------------------------------------------------------
-- Expected result: Part A prints something like "Expected
--   failure: Cannot DROP COLUMN 'Salary' because it is being
--   referenced by object 'vw_EmployeeSalarySchemaBound'." and
--   Salary is still in Employees afterward.
--   Part B runs with no error at all, and Employees ends this
--   file with exactly the same columns it started with --
--   Notes existed only briefly in between.
-- ------------------------------------------------------------