-- ============================================================
-- Exercise 07 - Chapter 09 (Stored Procedures)
-- Topic: RETURN with Status Code
-- ============================================================
--
-- Write the procedure dbo.TryGiveRaise:
--
-- Parameters:
--   @EmployeeID     INT
--   @RaisePercent   DECIMAL(5,2)
--
-- Logic:
--   1) If @RaisePercent is outside the 0 to 50 range -> this is a
--      genuinely invalid input, so THROW (not RETURN).
--   2) If @EmployeeID is not found in the Employees table -> this
--      is a normal status, so RETURN 1 (with no error).
--   3) If everything is valid: give the raise and RETURN 0.
--
-- Sample calls (for your own testing):
--   DECLARE @Status INT;
--   EXEC @Status = dbo.TryGiveRaise @EmployeeID = 3, @RaisePercent = 10;
--   PRINT @Status;   -- should print 0
--
--   EXEC @Status = dbo.TryGiveRaise @EmployeeID = 9999, @RaisePercent = 10;
--   PRINT @Status;   -- should print 1 (no error)
-- ============================================================

CREATE OR ALTER PROCEDURE dbo.TryGiveRaise
    @EmployeeID     INT,
    @RaisePercent   DECIMAL(5,2)
AS
BEGIN
    -- write your code here

END;
GO