/* ============================================================
   03-updatable-view-basic.sql
   ============================================================
   A view built from a SINGLE table, with no aggregate functions,
   no GROUP BY/DISTINCT, and no computed columns, is updatable:
   SQL Server can translate an INSERT/UPDATE/DELETE against the
   view directly into the same operation against the underlying
   table, because there is no ambiguity about which row/column
   it refers to.

   vw_HighEarners (from 02-view-with-filter.sql) qualifies, so we
   can modify data through it, not just read it.
   ============================================================ */

-- UPDATE through the view: give Reza Kamali a raise.
-- SQL Server rewrites this as an UPDATE against the real
-- Employees table -- the view itself stores no data of its own.
UPDATE vw_HighEarners
SET Salary = 88000
WHERE EmployeeID = 3;

SELECT * FROM Employees WHERE EmployeeID = 3;

-- INSERT through the view also works, as long as every NOT NULL
-- column of the base table that isn't in the view either has a
-- default or is nullable. Employees.DepartmentID isn't selected
-- by vw_HighEarners, so it's left NULL here.
INSERT INTO vw_HighEarners (EmployeeID, FirstName, LastName, Salary)
VALUES (6, 'Farid', 'Noori', 92000);

SELECT * FROM Employees WHERE EmployeeID = 6;

-- ------------------------------------------------------------
-- Expected result: Reza Kamali's salary becomes 88000 in the
--   real Employees table. The new row (Farid Noori, 92000)
--   appears in Employees too, with DepartmentID left NULL since
--   the view never mentioned that column.
-- ------------------------------------------------------------