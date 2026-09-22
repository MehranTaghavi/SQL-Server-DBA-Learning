/* ============================================================
   Test 03 - Successful call: bonus applied to all three employees
   ============================================================
   Run 01-create-type.sql and 02-procedure.sql first.
   ============================================================ */

-- salaries before, for Amir Moradi (7), Leila Jafari (8), Kaveh Norouzi (9)
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (7, 8, 9);

DECLARE @IDs dbo.EmployeeIDList;
INSERT INTO @IDs (EmployeeID) VALUES (7), (8), (9);

EXEC dbo.GiveBonusToMultipleEmployees
    @EmployeeIDs  = @IDs,
    @BonusPercent = 10;

-- salaries after
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID IN (7, 8, 9);

-- ------------------------------------------------------------
-- Expected result: all three salaries rise by 10%:
--   Amir Moradi:    13,000,000 -> 14,300,000
--   Leila Jafari:    9,000,000 ->  9,900,000
--   Kaveh Norouzi:  16,000,000 -> 17,600,000
--   All three change together, from a single EXEC call.
-- ------------------------------------------------------------