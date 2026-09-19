/* ============================================================
   Test 02 - Successful call: order placed + bonus applied
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that a valid call inserts the order AND raises
   the salary, both together.
   ============================================================ */

-- check Reza Karimi's (EmployeeID 3) salary before
SELECT EmployeeID, Salary FROM Employees WHERE EmployeeID = 3;

EXEC dbo.PlaceOrderWithBonus
    @EmployeeID   = 3,
    @OrderDate    = '2024-05-01',
    @TotalAmount  = 1000000,
    @BonusPercent = 5;

-- confirm both changes actually happened
SELECT EmployeeID, Salary FROM Employees WHERE EmployeeID = 3;
SELECT * FROM Orders WHERE EmployeeID = 3 ORDER BY OrderDate DESC;

-- ------------------------------------------------------------
-- Expected result: Reza Karimi's (EmployeeID 3) salary goes from
--   15,000,000 to 15,750,000 (5% bonus), and a new Orders row
--   for him with TotalAmount 1,000,000 appears, dated 2024-05-01.
-- ------------------------------------------------------------