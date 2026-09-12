/* ============================================================
   Exercise 02 - Input parameters + an OUTPUT parameter
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Insert a new employee and hand the caller back the new
   employee's EmployeeID immediately, without a second SELECT.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.AddEmployeeWithOutput
    @FirstName      NVARCHAR(50),
    @LastName       NVARCHAR(50),
    @DepartmentID   INT,
    @Salary         DECIMAL(10,2),
    @HireDate       DATE,
    @ManagerID      INT = NULL,
    @NewEmployeeID  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Employees (FirstName, LastName, ManagerID, DepartmentID, Salary, HireDate)
    VALUES (@FirstName, @LastName, @ManagerID, @DepartmentID, @Salary, @HireDate);

    SET @NewEmployeeID = SCOPE_IDENTITY();
END;
GO

-- ------------------------------------------------------------
-- Usage example
-- ------------------------------------------------------------

DECLARE @NewID INT;

EXEC dbo.AddEmployeeWithOutput
    @FirstName     = 'Nasrin',
    @LastName      = 'Karbasi',
    @DepartmentID  = 1,
    @Salary        = 13500000,
    @HireDate      = '2024-02-01',
    @ManagerID     = 1,
    @NewEmployeeID = @NewID OUTPUT;

SELECT @NewID AS NewEmployeeID;

-- confirm the row was actually inserted
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
FROM Employees
WHERE EmployeeID = @NewID;

-- ------------------------------------------------------------
-- Expected result: @NewID holds the EmployeeID that SQL Server
--   assigned to Nasrin Karbasi (11, if run once right after
--   00-setup.sql with no other inserts in between). The final
--   SELECT confirms the row exists with the values passed in.
-- ------------------------------------------------------------