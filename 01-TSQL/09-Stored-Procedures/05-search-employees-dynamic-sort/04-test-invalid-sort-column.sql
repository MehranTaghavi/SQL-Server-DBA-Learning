/* ============================================================
   Test 04 - Invalid sort column: rejected by the whitelist
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that a @SortColumn value outside the whitelist
   is rejected with THROW, BEFORE the dynamic SQL string is even
   built -- this is what stops someone from passing something
   like a subquery or an injected fragment as a "column name".
   ============================================================ */

EXEC dbo.SearchEmployeesDynamicSort
    @SortColumn = 'ManagerID';   -- a real column, but not on the whitelist

-- ------------------------------------------------------------
-- Expected result: the call raises "Invalid sort column." via
--   THROW, and no result set is returned at all -- the rejection
--   happens before @sql is ever constructed or executed.
-- ------------------------------------------------------------