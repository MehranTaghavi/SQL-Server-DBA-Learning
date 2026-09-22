/* ============================================================
   Test 05 - One invalid EmployeeID in the list: all-or-nothing
   ============================================================
   Run 01-create-type.sql and 02-procedure.sql first.

   Goal: Prove that when a list has TWO valid IDs and ONE invalid
   ID, the valid employees are NOT quietly given the bonus while
   the invalid one is skipped -- the whole call is rejected.
   ============================================================ */

-- salaries before, for Sara Ahmadi (2) and Mina Hosseini (4)
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (2, 4);

DECLARE @IDs dbo.EmployeeIDList;
INSERT INTO @IDs (EmployeeID) VALUES (2), (4), (9999);   -- 9999 doesn't exist

EXEC dbo.GiveBonusToMultipleEmployees
    @EmployeeIDs  = @IDs,
    @BonusPercent = 5;

-- confirm the two VALID employees were also left untouched
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (2, 4);

-- ------------------------------------------------------------
-- Expected result: the call raises "One or more EmployeeIDs do
--   not exist. No salaries were changed." via THROW. Sara Ahmadi
--   (2) and Mina Hosseini (4) -- both perfectly valid IDs -- are
--   NOT given the bonus, because the whole list is rejected as a
--   unit before BEGIN TRANSACTION is reached.
-- ------------------------------------------------------------