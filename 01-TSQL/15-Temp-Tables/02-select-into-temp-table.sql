/* ============================================================
   02-select-into-temp-table.sql
   ============================================================
   SELECT ... INTO #name creates the temp table AND fills it in
   one step, taking the column names and data types from the
   query -- no CREATE TABLE needed. It is the fastest way to
   park an intermediate result somewhere.
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #HighEarners;
DROP TABLE IF EXISTS #EmptyCopy;
GO

-- 1) Create + fill in one statement:
SELECT EmployeeID, FirstName, LastName, Salary
INTO #HighEarners
FROM Employees
WHERE Salary >= 85000;

SELECT EmployeeID, FirstName, LastName, Salary
FROM #HighEarners
ORDER BY Salary DESC;

-- 2) The data types were inherited from Employees:
SELECT COLUMN_NAME, DATA_TYPE
FROM tempdb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '#HighEarners%'
ORDER BY ORDINAL_POSITION;

-- 3) A handy trick: WHERE 1 = 0 copies only the STRUCTURE, no rows.
SELECT * INTO #EmptyCopy FROM Employees WHERE 1 = 0;
SELECT COUNT(*) AS RowsInEmptyCopy FROM #EmptyCopy;

DROP TABLE #HighEarners;
DROP TABLE #EmptyCopy;

-- ------------------------------------------------------------
-- Expected result:
--   1) 4 rows, highest salary first:
--        Mina Jafari 95000.00, Ali Ahmadi 90000.00,
--        Zahra Alavi 88000.00, Reza Kamali 85000.00
--   2) EmployeeID int | FirstName varchar | LastName varchar |
--      Salary decimal
--   3) RowsInEmptyCopy = 0 (the table exists with all 6 columns
--      of Employees, but contains no data)
-- ------------------------------------------------------------
