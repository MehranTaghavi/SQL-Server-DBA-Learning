/* ============================================================
   05-managing-triggers.sql
   ============================================================
   Listing, disabling, re-enabling and dropping triggers.
   Run 00-setup.sql and 01-after-update-audit-trigger.sql first
   (this file uses trg_Employees_SalaryAudit and the Employees /
   SalaryAudit tables). Both tests run inside transactions that
   are rolled back, so no data is left changed.
   ============================================================ */

-- 1) See which triggers exist in this database:
SELECT
    t.name                     AS TriggerName,
    OBJECT_NAME(t.parent_id)   AS TableName,
    t.is_instead_of_trigger    AS IsInsteadOf,
    t.is_disabled              AS IsDisabled
FROM sys.triggers t
WHERE t.parent_class_desc = 'OBJECT_OR_COLUMN'
ORDER BY TableName, TriggerName;

-- Note: ALTER TABLE ... DISABLE/ENABLE TRIGGER is equivalent to the
-- standalone DISABLE TRIGGER / ENABLE TRIGGER ... ON ... statements; the
-- ALTER TABLE form is used here because it is the form the sqlfluff
-- T-SQL parser used by this repo's CI can parse.

-- 2) Disable the audit trigger: an update no longer gets logged.
ALTER TABLE dbo.Employees DISABLE TRIGGER trg_Employees_SalaryAudit;

DECLARE @before INT = (SELECT COUNT(*) FROM SalaryAudit);
BEGIN TRANSACTION;
    UPDATE Employees SET Salary = Salary + 1000 WHERE EmployeeID = 1;
    SELECT 'Trigger DISABLED' AS State,
           (SELECT COUNT(*) FROM SalaryAudit) - @before AS NewAuditRows;
ROLLBACK TRANSACTION;

-- 3) Enable it again: the same update is logged once more.
ALTER TABLE dbo.Employees ENABLE TRIGGER trg_Employees_SalaryAudit;

SET @before = (SELECT COUNT(*) FROM SalaryAudit);
BEGIN TRANSACTION;
    UPDATE Employees SET Salary = Salary + 1000 WHERE EmployeeID = 1;
    SELECT 'Trigger ENABLED' AS State,
           (SELECT COUNT(*) FROM SalaryAudit) - @before AS NewAuditRows;
ROLLBACK TRANSACTION;

-- To remove a trigger permanently (not run here, so later files
-- keep working):
--   DROP TRIGGER dbo.trg_Employees_SalaryAudit;

-- ------------------------------------------------------------
-- Expected result:
--   Query 1: lists every trigger created by files 01-04 that is
--            still present (e.g. trg_Employees_SalaryAudit,
--            trg_Employees_Archive, trg_Customers_SoftDelete,
--            trg_DemoEmp_Audit), all with IsDisabled = 0, and
--            IsInsteadOf = 1 only for trg_Customers_SoftDelete.
--   Step 2:  'Trigger DISABLED' -> NewAuditRows = 0
--   Step 3:  'Trigger ENABLED'  -> NewAuditRows = 1
--   Disabling a trigger silently turns off whatever business rule
--   it enforced -- always re-enable it, and prefer doing this in
--   a controlled maintenance window.
-- ------------------------------------------------------------
