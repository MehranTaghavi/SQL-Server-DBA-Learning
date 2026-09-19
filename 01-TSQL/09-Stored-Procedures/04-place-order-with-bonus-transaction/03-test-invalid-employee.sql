/* ============================================================
   Test 03 - Invalid EmployeeID: full rollback
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that an invalid EmployeeID is rejected via
   THROW, and that SET XACT_ABORT ON + the explicit
   ROLLBACK TRANSACTION leave no partial order behind.
   ============================================================ */

-- how many orders currently reference this (nonexistent) EmployeeID
SELECT COUNT(*) AS OrderCountBefore FROM Orders WHERE EmployeeID = 9999;

EXEC dbo.PlaceOrderWithBonus
    @EmployeeID   = 9999,
    @OrderDate    = '2024-05-02',
    @TotalAmount  = 500000,
    @BonusPercent = 5;

-- confirm nothing was inserted despite the error
SELECT COUNT(*) AS OrderCountAfter FROM Orders WHERE EmployeeID = 9999;

-- ------------------------------------------------------------
-- Expected result: the EXEC call raises a custom error via THROW
--   ("No employee exists with the given EmployeeID."), and
--   OrderCountBefore and OrderCountAfter are both 0 -- no partial
--   order row is ever left behind.
-- ------------------------------------------------------------