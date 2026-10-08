/* ============================================================
   04-multi-statement-tvf.sql
   ============================================================
   A MULTI-STATEMENT table-valued function (MSTVF) also returns a
   table, but builds it step by step inside a declared table
   variable, rather than a single RETURN (SELECT ...). This makes
   it more flexible -- you can have several statements, branching
   logic, even multiple INSERTs into the return table -- but SQL
   Server treats the return table like an ordinary table variable:
   no real statistics, which can mislead the query optimizer on
   larger data. Prefer an inline TVF (02) whenever a single SELECT
   can express the same logic; reach for this style only when you
   genuinely need multiple steps.
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.GetSalaryBandSummary ()
RETURNS @Result TABLE
(
    SalaryBand   VARCHAR(20),
    EmployeeCount INT,
    AvgSalary     DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @Result (SalaryBand, EmployeeCount, AvgSalary)
    SELECT 'Under 80000', COUNT(*), AVG(Salary)
    FROM Employees
    WHERE Salary < 80000;

    INSERT INTO @Result (SalaryBand, EmployeeCount, AvgSalary)
    SELECT '80000 and above', COUNT(*), AVG(Salary)
    FROM Employees
    WHERE Salary >= 80000;

    RETURN;
END;
GO

SELECT * FROM dbo.GetSalaryBandSummary();

-- ------------------------------------------------------------
-- Expected result: 2 rows.
--   'Under 80000'     -> EmployeeCount 2, AvgSalary 72500.00
--     (Sara Nouri 75000, Nima Karimi 70000)
--   '80000 and above' -> EmployeeCount 3, AvgSalary 90000.00
--     (Ali Ahmadi 90000, Reza Kamali 85000, Mina Jafari 95000)
-- ------------------------------------------------------------
