/* ============================================================
   09-update-with-output.sql
   ============================================================
   A safe bulk-update pattern:
     1. Load the intended changes into a staging temp table.
     2. Run ONE set-based UPDATE ... JOIN against the real table.
     3. Use the OUTPUT clause to capture old and new values into
        a second temp table, as an audit trail.
   The real change runs inside a transaction that is ROLLED BACK
   here, so Employees is left untouched and the file is re-runnable.
   (Both temp tables are created BEFORE the transaction on purpose:
   a temp table created inside a transaction that is rolled back
   would disappear too.)
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #SalaryChanges;
DROP TABLE IF EXISTS #AuditLog;
GO

CREATE TABLE #SalaryChanges (EmployeeID INT, NewSalary DECIMAL(10,2));
CREATE TABLE #AuditLog (
    EmployeeID INT,
    OldSalary  DECIMAL(10,2),
    NewSalary  DECIMAL(10,2)
);

INSERT INTO #SalaryChanges (EmployeeID, NewSalary) VALUES
(1, 95000),
(4, 99000),
(6, 90000);

BEGIN TRANSACTION;

UPDATE e
SET e.Salary = c.NewSalary
OUTPUT inserted.EmployeeID, deleted.Salary, inserted.Salary
INTO #AuditLog (EmployeeID, OldSalary, NewSalary)
FROM Employees AS e
INNER JOIN #SalaryChanges AS c ON c.EmployeeID = e.EmployeeID;

SELECT EmployeeID, OldSalary, NewSalary FROM #AuditLog ORDER BY EmployeeID;

ROLLBACK TRANSACTION;

SELECT EmployeeID, Salary FROM Employees WHERE EmployeeID IN (1, 4, 6) ORDER BY EmployeeID;
SELECT COUNT(*) AS AuditRowsAfterRollback FROM #AuditLog;

DROP TABLE #SalaryChanges;
DROP TABLE #AuditLog;

-- ------------------------------------------------------------
-- Expected result:
--   Inside the transaction (#AuditLog): 3 rows --
--     1 | 90000.00 | 95000.00
--     4 | 95000.00 | 99000.00
--     6 | 88000.00 | 90000.00
--   After ROLLBACK: Employees salaries are back to
--     1 -> 90000.00, 4 -> 95000.00, 6 -> 88000.00
--   AuditRowsAfterRollback = 0 -- #AuditLog is a temp TABLE, so the
--     rollback removed the rows OUTPUT had inserted (compare with
--     a table variable in 06, which would have kept them).
-- ------------------------------------------------------------
