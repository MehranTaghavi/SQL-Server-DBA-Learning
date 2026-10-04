/* ============================================================
   05-non-updatable-view.sql
   ============================================================
   vw_EmployeeDepartmentSummary (from 01-create-basic-view.sql)
   joins TWO tables. A view built on a JOIN is updatable only
   under narrow conditions: a single UPDATE statement must touch
   columns belonging to exactly ONE of the underlying tables, not
   both at once -- SQL Server has no way to split one statement
   into two separate writes against two different tables.

   This file deliberately triggers the error, so you can see it
   for yourself rather than just reading about it.
   ============================================================ */

-- This UPDATE touches Salary (from Employees) and DepartmentName
-- (from Departments) IN THE SAME STATEMENT -- columns that come
-- from two different base tables through the JOIN.
UPDATE vw_EmployeeDepartmentSummary
SET Salary = 99000,
    DepartmentName = 'Engineering'
WHERE EmployeeID = 1;

-- ------------------------------------------------------------
-- Expected result: SQL Server rejects this with an error similar
--   to "View or function 'vw_EmployeeDepartmentSummary' is not
--   updatable because the modification affects multiple base
--   tables." Nothing changes in either Employees or Departments.
--
--   Contrast with 03-updatable-view-basic.sql: updating ONLY
--   Salary (a single Employees column) through this same view
--   would actually be allowed, because that touches only one
--   base table. It's the combination of columns from both
--   tables in ONE statement that's rejected, not the JOIN itself.
-- ------------------------------------------------------------