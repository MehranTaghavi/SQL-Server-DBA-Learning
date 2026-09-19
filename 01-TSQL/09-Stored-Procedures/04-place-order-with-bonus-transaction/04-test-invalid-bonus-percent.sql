/* ============================================================
   Test 04 - Invalid BonusPercent: rejected before BEGIN TRANSACTION
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that an out-of-range BonusPercent is rejected
   by validation that runs BEFORE BEGIN TRANSACTION, so employee
   5's data is completely untouched -- not even a transaction is
   opened.
   ============================================================ */

-- check Hossein Ghasemi's (EmployeeID 5) salary and order count before
SELECT EmployeeID, Salary FROM Employees WHERE EmployeeID = 5;
SELECT COUNT(*) AS OrderCountBefore FROM Orders WHERE EmployeeID = 5;

EXEC dbo.PlaceOrderWithBonus
    @EmployeeID   = 5,
    @OrderDate    = '2024-05-03',
    @TotalAmount  = 300000,
    @BonusPercent = 80;

-- confirm employee 5 was not affected in any way
SELECT EmployeeID, Salary FROM Employees WHERE EmployeeID = 5;
SELECT COUNT(*) AS OrderCountAfter FROM Orders WHERE EmployeeID = 5;

-- ------------------------------------------------------------
-- Expected result: the EXEC call raises "BonusPercent must be
--   between 0 and 50." via THROW, before BEGIN TRANSACTION is
--   ever reached. Employee 5's Salary is unchanged, and
--   OrderCountBefore equals OrderCountAfter.
-- ------------------------------------------------------------