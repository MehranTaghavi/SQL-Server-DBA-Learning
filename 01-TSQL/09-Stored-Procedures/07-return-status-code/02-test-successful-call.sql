/* ============================================================
   Test 02 - Successful call: RETURN 0
   ============================================================
   Run 01-procedure.sql first.
   ============================================================ */

DECLARE @Status INT;

-- salary before, for Reza Karimi (3)
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID = 3;

EXEC @Status = dbo.TryGiveRaise
    @EmployeeID   = 3,
    @RaisePercent = 10;

SELECT @Status AS ReturnStatus;

-- salary after
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE EmployeeID = 3;

-- ------------------------------------------------------------
-- Expected result: ReturnStatus = 0. Reza Karimi's salary rises
--   from 15,000,000 to 16,500,000 (10% raise).
-- ------------------------------------------------------------