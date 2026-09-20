/* ============================================================
   Exercise 05 - Dynamic SQL with sp_executesql
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the 07-CTE folder).

   Goal: A search procedure with optional filters (DepartmentID,
   MinSalary) and a user-selectable sort column, built safely
   with sp_executesql:
     - Filter VALUES are passed as real parameters (never
       string-concatenated) -- this is what prevents SQL
       injection and allows plan reuse.
     - The sort column is an IDENTIFIER, not a value, so it
       cannot be parameterized the same way. It is instead
       checked against a whitelist and wrapped in QUOTENAME().

   Run this file once to create the procedure, then run
   02, 03, and 04 in this folder to see it in action.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.SearchEmployeesDynamicSort
    @DepartmentID INT           = NULL,
    @MinSalary    DECIMAL(10,2) = NULL,
    @SortColumn   NVARCHAR(50)  = 'EmployeeID'
AS
BEGIN
    SET NOCOUNT ON;

    -- Identifiers can't be parameterized by sp_executesql, so the
    -- sort column must be validated against a fixed whitelist
    -- BEFORE it ever touches the SQL string.
    IF @SortColumn NOT IN ('EmployeeID', 'LastName', 'Salary', 'HireDate')
    BEGIN
        THROW 51020, 'Invalid sort column.', 1;
    END

    DECLARE @sql    NVARCHAR(MAX) = N'SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate FROM Employees WHERE 1 = 1';
    DECLARE @params NVARCHAR(MAX) = N'@DepartmentID INT, @MinSalary DECIMAL(10,2)';

    IF @DepartmentID IS NOT NULL
        SET @sql += N' AND DepartmentID = @DepartmentID';

    IF @MinSalary IS NOT NULL
        SET @sql += N' AND Salary >= @MinSalary';

    -- QUOTENAME() wraps the already-validated identifier in [ ]
    -- so it is always treated as a column name, never as
    -- executable text.
    SET @sql += N' ORDER BY ' + QUOTENAME(@SortColumn);

    EXEC sp_executesql
        @sql,
        @params,
        @DepartmentID = @DepartmentID,
        @MinSalary    = @MinSalary;
END;
GO