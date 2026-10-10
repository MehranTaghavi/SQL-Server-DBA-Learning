/* ============================================================
   04-multi-row-pitfall.sql
   ============================================================
   THE classic trigger bug: a trigger fires once per STATEMENT,
   not once per row. If one UPDATE touches 3 rows, 'inserted'
   contains 3 rows -- but code that assigns from it into a scalar
   variable can only hold one of them.

   Fully self-contained: uses its own throwaway DemoEmp/DemoAudit
   tables.
   ============================================================ */

DROP TABLE IF EXISTS DemoAudit;
DROP TABLE IF EXISTS DemoEmp;
GO

CREATE TABLE DemoEmp  (EmployeeID INT PRIMARY KEY, Salary DECIMAL(10,2));
CREATE TABLE DemoAudit (EmployeeID INT, NewSalary DECIMAL(10,2));
INSERT INTO DemoEmp VALUES (1, 100), (2, 200), (3, 300);
GO

-- BAD: assumes 'inserted' holds exactly one row.
CREATE TRIGGER dbo.trg_DemoEmp_Audit
ON dbo.DemoEmp
AFTER UPDATE
AS
BEGIN
    DECLARE @id INT, @sal DECIMAL(10,2);
    SELECT @id = EmployeeID, @sal = Salary FROM inserted;   -- keeps ONE row only
    INSERT INTO dbo.DemoAudit VALUES (@id, @sal);
END;
GO

UPDATE DemoEmp SET Salary = Salary + 50;      -- touches all 3 rows
SELECT 'Bad trigger' AS Version, COUNT(*) AS AuditRows FROM DemoAudit;
GO

-- FIX: replace the trigger with a set-based version.
DROP TRIGGER dbo.trg_DemoEmp_Audit;
GO

DELETE FROM DemoAudit;
UPDATE DemoEmp SET Salary = EmployeeID * 100;  -- reset (no trigger exists right now)
GO

CREATE TRIGGER dbo.trg_DemoEmp_Audit
ON dbo.DemoEmp
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.DemoAudit (EmployeeID, NewSalary)
    SELECT EmployeeID, Salary FROM inserted;   -- ALL affected rows
END;
GO

UPDATE DemoEmp SET Salary = Salary + 50;      -- again touches all 3 rows
SELECT 'Set-based trigger' AS Version, COUNT(*) AS AuditRows FROM DemoAudit;
SELECT EmployeeID, NewSalary FROM DemoAudit ORDER BY EmployeeID;

-- ------------------------------------------------------------
-- Expected result:
--   'Bad trigger'        -> AuditRows = 1  (3 rows were updated, only
--                           one was logged -- and which one is not
--                           guaranteed)
--   'Set-based trigger'  -> AuditRows = 3
--   Final SELECT         -> (1, 150.00), (2, 250.00), (3, 350.00)
--   Rule of thumb: write every trigger as if 'inserted' and
--   'deleted' always contain many rows (or zero rows).
-- ------------------------------------------------------------
