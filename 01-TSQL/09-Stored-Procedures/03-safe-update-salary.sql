/* ============================================================
   Exercise 03 - TRY...CATCH + validation
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Update an employee's salary, but reject the update (with
   a clear custom error, not a confusing constraint failure) if
   the new salary is not a positive number.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.SafeUpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary  DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @NewSalary <= 0
        BEGIN
            THROW 51000, 'Salary must be a positive number.', 1;
        END

        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            THROW 51001, 'No employee exists with the given EmployeeID.', 1;
        END

        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        PRINT 'Salary updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Update failed: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ------------------------------------------------------------
-- Usage examples
-- ------------------------------------------------------------

-- a valid update: succeeds
EXEC dbo.SafeUpdateEmployeeSalary @EmployeeID = 4, @NewSalary = 13000000;

-- an invalid update: caught and reported, nothing changes
EXEC dbo.SafeUpdateEmployeeSalary @EmployeeID = 4, @NewSalary = -500;

-- an invalid EmployeeID: caught and reported, nothing changes
EXEC dbo.SafeUpdateEmployeeSalary @EmployeeID = 9999, @NewSalary = 12000000;

-- confirm employee 4's final salary
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID = 4;

-- ------------------------------------------------------------
-- Expected result: the first EXEC prints a success message and
--   actually changes Mina Hosseini's salary to 13,000,000. The
--   second and third EXEC calls each print a "Update failed: ..."
--   message from ERROR_MESSAGE() and change nothing. The final
--   SELECT confirms the salary is 13,000,000, not affected by
--   the two failed attempts.
-- ------------------------------------------------------------