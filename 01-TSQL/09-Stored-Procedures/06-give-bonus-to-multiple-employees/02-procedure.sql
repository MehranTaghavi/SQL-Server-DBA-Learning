/* ============================================================
   Exercise 06 - Table-Valued Parameters (TVP)
   Step 2 of 2: the procedure
   ============================================================
   Run 01-create-type.sql first.

   Goal: Apply the same percentage bonus to an ENTIRE LIST of
   employees in a single call, atomically -- either every listed
   employee's salary is raised, or (on any validation failure)
   none of them are.

   This builds on two earlier exercises at once:
     - Exercise 04's transaction + TRY...CATCH pattern
       (SET XACT_ABORT ON, BEGIN TRANSACTION / ROLLBACK, THROW)
     - This exercise's new ingredient: a TVP replaces what would
       otherwise have to be N separate calls to a single-employee
       bonus procedure, or a fragile comma-separated ID string.

   Three validation rules, each checked BEFORE the transaction
   opens, so an invalid call never touches the transaction log:
     1. The list must not be empty.
     2. BonusPercent must be between 0 and 50.
     3. EVERY EmployeeID in the list must already exist in
        Employees -- this is an all-or-nothing list, not a
        best-effort one.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GiveBonusToMultipleEmployees
    @EmployeeIDs  dbo.EmployeeIDList READONLY,   -- READONLY is mandatory for every TVP parameter
    @BonusPercent DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        -- Rule 1: the caller must actually supply at least one row.
        -- A TVP with zero rows is valid T-SQL (no error on its own),
        -- so this has to be checked explicitly.
        IF NOT EXISTS (SELECT 1 FROM @EmployeeIDs)
        BEGIN
            THROW 51030, 'EmployeeIDs list cannot be empty.', 1;
        END

        -- Rule 2: same range check used in earlier exercises.
        IF @BonusPercent < 0 OR @BonusPercent > 50
        BEGIN
            THROW 51031, 'BonusPercent must be between 0 and 50.', 1;
        END

        -- Rule 3: LEFT JOIN the TVP against Employees and look for
        -- any row that found no match. If even one exists, the
        -- whole call is rejected -- we do NOT silently apply the
        -- bonus to only the valid subset.
        IF EXISTS
        (
            SELECT 1
            FROM @EmployeeIDs AS ids
            LEFT JOIN Employees AS e ON e.EmployeeID = ids.EmployeeID
            WHERE e.EmployeeID IS NULL
        )
        BEGIN
            THROW 51032, 'One or more EmployeeIDs do not exist. No salaries were changed.', 1;
        END

        BEGIN TRANSACTION;

        -- A set-based UPDATE ... FROM ... JOIN, not a loop: every
        -- matching employee is raised in one statement.
        UPDATE e
        SET e.Salary = e.Salary + (e.Salary * @BonusPercent / 100)
        FROM Employees AS e
        INNER JOIN @EmployeeIDs AS ids ON ids.EmployeeID = e.EmployeeID;

        COMMIT TRANSACTION;

        PRINT 'Bonus applied to all listed employees successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO