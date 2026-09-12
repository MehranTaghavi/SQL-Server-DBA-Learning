/* ============================================================
   Exercise 01 - Basic procedure with an optional parameter
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Write a reusable procedure that returns the employees
   of a single department when a DepartmentID is given, or every
   employee in the company when no DepartmentID is given at all.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetEmployeesByDepartment
    @DepartmentID INT = NULL   -- optional: NULL means "all departments"
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        d.DepartmentName,
        e.Salary,
        e.HireDate
    FROM Employees AS e
    INNER JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
    WHERE @DepartmentID IS NULL OR e.DepartmentID = @DepartmentID
    ORDER BY d.DepartmentName, e.Salary DESC;
END;
GO

-- ------------------------------------------------------------
-- Usage examples
-- ------------------------------------------------------------

-- only the IT department (DepartmentID = 1)
EXEC dbo.GetEmployeesByDepartment @DepartmentID = 1;

-- every employee in the company, since no parameter is passed
EXEC dbo.GetEmployeesByDepartment;

-- ------------------------------------------------------------
-- Expected result: the first call returns only Ali, Sara, and
--   Mina (the three IT employees from 00-setup.sql). The second
--   call, with no parameter, returns all 10 employees across
--   every department.
-- ------------------------------------------------------------