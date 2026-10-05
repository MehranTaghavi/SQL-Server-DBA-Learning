/* ============================================================
   11-indexed-view-maintenance.sql
   ============================================================
   Run 09 and 10 first.

   Indexed views are maintained automatically when base-table data
   changes. This file shows that maintenance in real time, then
   rolls everything back so the dataset stays unchanged.
   ============================================================ */

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
WHERE DepartmentID = 1;

BEGIN TRAN;

INSERT INTO dbo.Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary)
VALUES (99, 'Demo', 'IndexedView', 1, 91000);

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
WHERE DepartmentID = 1;

UPDATE dbo.Employees
SET Salary = 93000
WHERE EmployeeID = 99;

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
WHERE DepartmentID = 1;

ROLLBACK TRAN;

SELECT *
FROM dbo.vw_DepartmentSalaryTotals
WHERE DepartmentID = 1;

-- ------------------------------------------------------------
-- Expected result:
--   1) After INSERT: DepartmentID 1 EmployeeCount increases by 1
--      and TotalSalary increases by 91000.
--   2) After UPDATE: same row's TotalSalary increases by +2000.
--   3) After ROLLBACK: values return to the original baseline.
--
-- This proves indexed-view rows are automatically synchronized
-- with base-table writes; no manual refresh is needed.
-- ------------------------------------------------------------
