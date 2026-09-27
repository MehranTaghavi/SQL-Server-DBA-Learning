/* ============================================================
   Exercise 07 - RETURN status codes
   ============================================================
   See ../Return-Status-Code-Concept.md for the full theory.

   Goal: Give an employee a raise, but distinguish between two
   very different kinds of "didn't fully succeed":
     - An out-of-range RaisePercent is a genuinely invalid call
       -> THROW.
     - A nonexistent EmployeeID is a normal, expected outcome in
       a lookup-then-act workflow, not a bug in the caller
       -> RETURN a status code instead, no exception raised.

   Run this file once to create the procedure, then run
   02, 03, and 04 in this folder to see it in action.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.TryGiveRaise
    @EmployeeID   INT,
    @RaisePercent DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Genuinely invalid input -> THROW, not RETURN.
    IF @RaisePercent < 0 OR @RaisePercent > 50
    BEGIN
        THROW 51040, 'RaisePercent must be between 0 and 50.', 1;
    END

    -- A missing employee is a normal outcome here, not an error
    -- -> RETURN a status code instead of raising an exception.
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        RETURN 1;   -- 1 = employee not found
    END

    UPDATE Employees
    SET Salary = Salary * (1 + @RaisePercent / 100.0)
    WHERE EmployeeID = @EmployeeID;

    RETURN 0;   -- 0 = success
END;
GO