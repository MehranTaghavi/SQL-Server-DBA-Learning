/* ============================================================
   Test 06 - Empty list
   ============================================================
   Run 01-create-type.sql and 02-procedure.sql first.

   Goal: A TVP with zero rows is perfectly valid T-SQL by itself
   -- it does not raise an error on its own. This test proves the
   procedure's own explicit emptiness check catches it instead.
   ============================================================ */

DECLARE @IDs dbo.EmployeeIDList;   -- declared, but never populated

EXEC dbo.GiveBonusToMultipleEmployees
    @EmployeeIDs  = @IDs,
    @BonusPercent = 5;

-- ------------------------------------------------------------
-- Expected result: the call raises "EmployeeIDs list cannot be
--   empty." via THROW. No table in the database is touched at
--   all, since this check runs before any Employees table is
--   even referenced.
-- ------------------------------------------------------------