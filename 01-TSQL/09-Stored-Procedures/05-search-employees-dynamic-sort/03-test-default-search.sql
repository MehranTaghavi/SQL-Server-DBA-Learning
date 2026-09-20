/* ============================================================
   Test 03 - No filters, default sort column
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that when both filters are omitted, all
   employees are returned, and that @SortColumn defaults to
   'EmployeeID' when the caller doesn't specify one.
   ============================================================ */

EXEC dbo.SearchEmployeesDynamicSort;

-- ------------------------------------------------------------
-- Expected result: all 10 employees, ordered by EmployeeID
--   ascending (1 through 10) -- neither the WHERE clause nor the
--   ORDER BY clause was restricted, since both parameters use
--   their defaults.
-- ------------------------------------------------------------