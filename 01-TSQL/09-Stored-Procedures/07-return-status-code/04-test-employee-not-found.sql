/* ============================================================
   Test 04 - Employee not found: RETURN 1, no exception raised
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that a nonexistent EmployeeID does NOT raise an
   error -- it is treated as a normal outcome. Unlike Test 03,
   the batch continues normally after the EXEC call, because
   nothing here was actually invalid.
   ============================================================ */

DECLARE @Status INT;

EXEC @Status = dbo.TryGiveRaise
    @EmployeeID   = 9999,   -- does not exist
    @RaisePercent = 10;

SELECT @Status AS ReturnStatus;   -- this line DOES run

-- ------------------------------------------------------------
-- Expected result: ReturnStatus = 1. No error is raised anywhere
--   -- this batch completes normally, unlike Test 03. The caller
--   is expected to check ReturnStatus and decide what to do,
--   exactly like checking any other return value.
-- ------------------------------------------------------------