/* ============================================================
   02-inline-tvf-employees-by-dept.sql
   ============================================================
   An INLINE table-valued function (iTVF) returns a table, built
   from a single RETURN (SELECT ...) -- essentially a view that
   accepts parameters. The query optimizer can expand it inline
   into the surrounding query, the same way it treats a view, so
   this style generally performs well.
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.GetEmployeesByDept (@DeptName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Salary
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DeptName
);
GO

-- Query it exactly like a parameterized table:
SELECT * FROM dbo.GetEmployeesByDept('IT');

SELECT * FROM dbo.GetEmployeesByDept('Sales')
ORDER BY Salary DESC;

-- ------------------------------------------------------------
-- Expected result (first query): 2 rows -- Ali Ahmadi (90000)
--   and Mina Jafari (95000), the two IT employees.
-- Expected result (second query): 2 rows -- Reza Kamali (85000)
--   and Nima Karimi (70000), highest salary first.
-- ------------------------------------------------------------
