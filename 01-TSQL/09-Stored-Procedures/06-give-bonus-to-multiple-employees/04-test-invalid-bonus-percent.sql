/* ============================================================
   Test 04 - Invalid BonusPercent: rejected before BEGIN TRANSACTION
   ============================================================
   Run 01-create-type.sql and 02-procedure.sql first.
   ============================================================ */

-- salaries before, for Ali Rezaei (1) and Sara Ahmadi (2)
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (1, 2);

DECLARE @IDs dbo.EmployeeIDList;
INSERT INTO @IDs (EmployeeID) VALUES (1), (2);

EXEC dbo.GiveBonusToMultipleEmployees
    @EmployeeIDs  = @IDs,
    @BonusPercent = 60;   -- out of the allowed 0-50 range

-- confirm neither employee was touched
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (1, 2);

-- ------------------------------------------------------------
-- Expected result: the call raises "BonusPercent must be between
--   0 and 50." via THROW, before BEGIN TRANSACTION is ever reached.
--   Both employees' salaries are completely unchanged.
-- ------------------------------------------------------------