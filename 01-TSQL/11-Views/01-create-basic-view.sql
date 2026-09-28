/* ============================================================
   01-create-basic-view.sql
   ============================================================
   A VIEW is a saved SELECT query that you can query again and
   again as if it were a table -- it does not store its own copy
   of the data; every time you SELECT from it, SQL Server runs
   the query behind it against the real tables.

   Here, the view hides a two-table JOIN behind a simple name,
   so anyone using it never has to write that JOIN themselves.
   ============================================================ */

CREATE OR ALTER VIEW vw_EmployeeDepartmentSummary AS
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- Querying a view looks exactly like querying a table:
SELECT * FROM vw_EmployeeDepartmentSummary;

-- You can filter, sort, and use WHERE on a view too, just like
-- an ordinary table -- SQL Server combines your WHERE with the
-- view's own query behind the scenes.
SELECT *
FROM vw_EmployeeDepartmentSummary
WHERE DepartmentName = 'IT'
ORDER BY Salary DESC;

-- ------------------------------------------------------------
-- Expected result (first query): 5 rows, one per employee, each
--   already showing its DepartmentName instead of a raw
--   DepartmentID -- the JOIN happened, but nobody had to write it.
-- Expected result (second query): 2 rows -- Mina Jafari (95000)
--   and Ali Ahmadi (90000), the two IT employees, highest salary
--   first.
-- ------------------------------------------------------------