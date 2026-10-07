/* ============================================================
   03-apply-operator.sql
   ============================================================
   02-inline-tvf-employees-by-dept.sql called the function with a
   FIXED string literal ('IT', 'Sales'). But what if the
   parameter needs to come from EACH ROW of another table instead
   -- here, each department's own name? A plain JOIN can't do
   that (a JOIN's ON condition can't call a function per row the
   way APPLY can). CROSS APPLY runs the function once PER ROW of
   the left-hand table, feeding that row's own column in as the
   parameter.
   ============================================================ */

-- For every department, pull in its own employees via the
-- function -- DepartmentName here comes from the CURRENT row of
-- Departments, not a literal.
SELECT
    d.DepartmentName,
    emp.FirstName,
    emp.LastName,
    emp.Salary
FROM Departments d
CROSS APPLY dbo.GetEmployeesByDept(d.DepartmentName) emp
ORDER BY d.DepartmentName, emp.Salary DESC;

-- OUTER APPLY is the equivalent of a LEFT JOIN for this pattern:
-- departments with NO employees still appear, with NULLs instead
-- of being dropped entirely. (None of our 3 departments are
-- empty, so compare this result to the CROSS APPLY one above --
-- they'll look identical here, but OUTER APPLY is what you'd
-- reach for the moment a department COULD have zero employees.)
SELECT
    d.DepartmentName,
    emp.FirstName,
    emp.LastName,
    emp.Salary
FROM Departments d
OUTER APPLY dbo.GetEmployeesByDept(d.DepartmentName) emp
ORDER BY d.DepartmentName, emp.Salary DESC;

-- ------------------------------------------------------------
-- Expected result (both queries): 5 rows -- all employees, each
--   paired with their own DepartmentName, grouped by department.
--   CROSS APPLY and OUTER APPLY return the same 5 rows here
--   because every department already has at least one employee.
-- ------------------------------------------------------------
