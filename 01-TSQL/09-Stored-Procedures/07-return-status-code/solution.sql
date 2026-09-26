-- ============================================================
-- Solution for Exercise 07 - Chapter 09 (Stored Procedures)
-- Topic: RETURN with Status Code
-- ============================================================

CREATE OR ALTER PROCEDURE dbo.TryGiveRaise
    @EmployeeID     INT,
    @RaisePercent   DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1) Genuinely invalid input -> THROW (not RETURN)
    IF @RaisePercent < 0 OR @RaisePercent > 50
    BEGIN
        THROW 50000, 'RaisePercent must be between 0 and 50.', 1;
    END

    -- 2) Normal status: employee not found -> RETURN 1 (no error)
    IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        RETURN 1;
    END

    -- 3) Success path: apply the raise
    UPDATE dbo.Employees
    SET Salary = Salary * (1 + @RaisePercent / 100.0)
    WHERE EmployeeID = @EmployeeID;

    RETURN 0;
END;
GO

-- ============================================================
-- Test
-- ============================================================
DECLARE @Status INT;

EXEC @Status = dbo.TryGiveRaise @EmployeeID = 3, @RaisePercent = 10;
PRINT @Status;   -- should print 0

EXEC @Status = dbo.TryGiveRaise @EmployeeID = 9999, @RaisePercent = 10;
PRINT @Status;   -- should print 1 (no error)

-- This line should THROW (invalid percent):
-- EXEC @Status = dbo.TryGiveRaise @EmployeeID = 3, @RaisePercent = 75;