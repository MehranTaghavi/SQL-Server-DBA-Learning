/* ============================================================
   04-check-option.sql
   ============================================================
   vw_HighEarners has a WHERE clause (Salary > 80000). By default,
   SQL Server lets you UPDATE a row through this view so that it
   no longer satisfies that WHERE clause -- the row just quietly
   disappears from the view afterward, even though the UPDATE
   itself succeeded.

   WITH CHECK OPTION changes this: it REJECTS any INSERT/UPDATE
   through the view that would produce a row the view's own
   WHERE clause wouldn't include.
   ============================================================ */

-- Part 1: default behavior, WITHOUT CHECK OPTION (the row simply
-- vanishes from the view, no error).
UPDATE vw_HighEarners
SET Salary = 50000      -- drops below the view's own WHERE Salary > 80000
WHERE EmployeeID = 6;   -- Farid Noori, inserted in the previous file

SELECT * FROM Employees WHERE EmployeeID = 6;         -- row is still there, Salary = 50000
SELECT * FROM vw_HighEarners WHERE EmployeeID = 6;     -- but it no longer shows up here

-- Part 2: recreate the view WITH CHECK OPTION.
CREATE OR ALTER VIEW vw_HighEarners AS
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > 80000
WITH CHECK OPTION;
GO

-- Restore Farid Noori above the threshold so this file is
-- re-runnable from a clean state.
UPDATE Employees SET Salary = 92000 WHERE EmployeeID = 6;

-- Now the same kind of UPDATE is REJECTED outright:
UPDATE vw_HighEarners
SET Salary = 50000
WHERE EmployeeID = 6;

-- ------------------------------------------------------------
-- Expected result, Part 1: the UPDATE succeeds silently. Farid
--   Noori's Salary becomes 50000 in Employees, but the second
--   SELECT (from the view) returns zero rows for EmployeeID 6 --
--   the row is still real data, just no longer visible through
--   this particular lens.
-- Expected result, Part 2: SQL Server raises an error ("The
--   attempted insert or update failed because the target view
--   either specifies WITH CHECK OPTION or spans a view that
--   specifies WITH CHECK OPTION..."). Farid Noori's Salary stays
--   at 92000 -- the UPDATE never happens at all.
-- ------------------------------------------------------------