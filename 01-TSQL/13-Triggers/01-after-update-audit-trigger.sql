/* ============================================================
   01-after-update-audit-trigger.sql
   ============================================================
   A TRIGGER is code attached to a table that SQL Server runs
   automatically when an INSERT, UPDATE or DELETE happens on it
   -- you never call it yourself.

   An AFTER trigger runs once the statement's changes have been
   made. Inside it, two special pseudo-tables are available:
     - inserted : the NEW version of every affected row
     - deleted  : the OLD version of every affected row
   (For an UPDATE, both exist: deleted = before, inserted = after.)

   Run 00-setup.sql first.
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_Employees_SalaryAudit
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Fires on ANY update to Employees; skip quickly if Salary
    -- wasn't one of the columns being updated.
    IF NOT UPDATE(Salary) RETURN;

    -- Set-based: handles 1 row or 1,000 rows in a single statement.
    INSERT INTO dbo.SalaryAudit (EmployeeID, OldSalary, NewSalary)
    SELECT i.EmployeeID, d.Salary, i.Salary
    FROM inserted i
    JOIN deleted  d ON d.EmployeeID = i.EmployeeID
    WHERE i.Salary <> d.Salary;   -- ignore rows whose salary didn't really change
END;
GO

-- 1) Single-row update:
UPDATE Employees SET Salary = 95000 WHERE EmployeeID = 1;

-- 2) Multi-row update -- ONE statement, TWO rows affected:
UPDATE Employees SET Salary = Salary * 1.10 WHERE EmployeeID IN (2, 3);

-- 3) Update that does NOT touch Salary -- should log nothing:
UPDATE Employees SET FirstName = 'Alireza' WHERE EmployeeID = 1;

SELECT AuditID, EmployeeID, OldSalary, NewSalary FROM SalaryAudit ORDER BY AuditID;

-- ------------------------------------------------------------
-- Expected result: 3 audit rows (the FirstName-only update in
--   step 3 produced none):
--     EmployeeID 1 : 90000.00 -> 95000.00
--     EmployeeID 2 : 75000.00 -> 82500.00
--     EmployeeID 3 : 85000.00 -> 93500.00
--   The two rows from step 2 came from a SINGLE UPDATE statement,
--   so the trigger fired once and handled both rows together.
--   ChangedAt / ChangedBy are filled in automatically by defaults.
-- ------------------------------------------------------------
