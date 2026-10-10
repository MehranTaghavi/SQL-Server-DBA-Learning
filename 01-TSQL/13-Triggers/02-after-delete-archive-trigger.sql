/* ============================================================
   02-after-delete-archive-trigger.sql
   ============================================================
   An AFTER DELETE trigger only has the 'deleted' pseudo-table
   (there is no 'inserted' for a DELETE). Here it copies every
   removed row into an archive table, so deletions can be
   recovered or reviewed later.

   The test runs inside a transaction that is ROLLED BACK at the
   end, so Employees is left exactly as it was and this file can
   be re-run any number of times.
   Run 00-setup.sql first.
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_Employees_Archive
ON dbo.Employees
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeArchive (EmployeeID, FirstName, LastName, Salary)
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM deleted;
END;
GO

BEGIN TRANSACTION;

DELETE FROM Employees WHERE EmployeeID = 3;

SELECT 'Employees after delete' AS Step, COUNT(*) AS RowsLeft FROM Employees;
SELECT EmployeeID, FirstName, LastName, Salary FROM EmployeeArchive;

ROLLBACK TRANSACTION;   -- undo the delete AND the archive row

SELECT 'Employees after rollback' AS Step, COUNT(*) AS RowsLeft FROM Employees;

-- ------------------------------------------------------------
-- Expected result:
--   'Employees after delete'   -> 2 rows left
--   EmployeeArchive            -> 1 row: Reza Kamali (EmployeeID 3)
--   'Employees after rollback' -> 3 rows left again
--   The trigger runs INSIDE the same transaction as the DELETE,
--   so the rollback also removed the archive row -- a trigger's
--   work succeeds or fails together with the statement that fired it.
-- ------------------------------------------------------------
