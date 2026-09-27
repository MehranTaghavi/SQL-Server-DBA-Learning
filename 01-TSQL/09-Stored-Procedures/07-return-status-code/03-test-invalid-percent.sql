/* ============================================================
   Test 03 - Invalid RaisePercent: THROW, not RETURN
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that an out-of-range RaisePercent is treated as
   a genuine error (THROW), not a status code. Because this
   raises an uncaught exception, the batch stops at the EXEC
   line -- @Status is never assigned, and the SELECT below never
   runs. That is expected: this is the whole point of the
   RETURN-vs-THROW distinction.
   ============================================================ */

DECLARE @Status INT;

EXEC @Status = dbo.TryGiveRaise
    @EmployeeID   = 3,
    @RaisePercent = 70;   -- out of the allowed 0-50 range

SELECT @Status AS ReturnStatus;   -- this line is never reached

-- ------------------------------------------------------------
-- Expected result: the call raises "RaisePercent must be between
--   0 and 50." via THROW. The batch stops there -- @Status is
--   never set, and the final SELECT never executes. This is
--   different from Test 04, where a missing employee produces a
--   status code instead of stopping the batch.
-- ------------------------------------------------------------