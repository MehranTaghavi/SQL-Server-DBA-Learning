/* ============================================================
   Exercise 04 - Transactions + TRY...CATCH: an atomic
   two-step procedure
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Place a new order for an employee AND give that same
   employee a percentage bonus on their salary, as a single
   atomic operation. If the employee does not exist, or the
   requested bonus percentage is invalid, NEITHER the order nor
   the salary change should happen.

   Run this file once to create the procedure, then run
   02, 03, and 04 in this folder to see it in action.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.PlaceOrderWithBonus
    @EmployeeID   INT,
    @OrderDate    DATE,
    @TotalAmount  DECIMAL(10,2),
    @BonusPercent DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            THROW 51010, 'No employee exists with the given EmployeeID.', 1;
        END

        IF @BonusPercent < 0 OR @BonusPercent > 50
        BEGIN
            THROW 51011, 'BonusPercent must be between 0 and 50.', 1;
        END

        BEGIN TRANSACTION;

        INSERT INTO Orders (EmployeeID, OrderDate, TotalAmount)
        VALUES (@EmployeeID, @OrderDate, @TotalAmount);

        UPDATE Employees
        SET Salary = Salary + (Salary * @BonusPercent / 100)
        WHERE EmployeeID = @EmployeeID;

        COMMIT TRANSACTION;

        PRINT 'Order placed and bonus applied successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO