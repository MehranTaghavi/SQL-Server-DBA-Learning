/* ============================================================
   06-schemabinding-basic.sql
   ============================================================
   WITH SCHEMABINDING locks a view to the exact schema of the
   columns it references: as long as the view exists, SQL Server
   will not let anyone ALTER or DROP a column the view depends
   on in a way that would break it.

   Two syntax requirements come with this, both enforced at
   CREATE time:
     1. Every table must be referenced with its two-part name
        (schema.table, e.g. dbo.Employees) -- not just Employees.
     2. The column list must be explicit (SELECT col1, col2, ...)
        -- SELECT * is not allowed in a schemabound view.
   ============================================================ */

CREATE OR ALTER VIEW vw_EmployeeSalarySchemaBound
WITH SCHEMABINDING
AS
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM dbo.Employees;
GO

-- Behaves exactly like any other view for querying:
SELECT * FROM vw_EmployeeSalarySchemaBound
ORDER BY Salary DESC;

-- ------------------------------------------------------------
-- Expected result: same 6 employees you'd see querying
--   Employees directly, just without DepartmentID -- this view
--   only exposes EmployeeID, FirstName, LastName, and Salary.
--   The protection this file's WITH SCHEMABINDING provides isn't
--   visible yet here; it shows up in 07-schemabinding-protection.sql.
-- ------------------------------------------------------------