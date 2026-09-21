/* ============================================================
   Exercise 10 - FIRST_VALUE / LAST_VALUE and a moving average
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: For every order, show that same employee's first order
   amount, their most recent (last) order amount so far, and a
   2-order moving average -- three patterns that build directly
   on the window frame concept from Exercise 07.
   ============================================================ */

SELECT
    o.OrderID,
    o.EmployeeID,
    o.OrderDate,
    o.TotalAmount,
    FIRST_VALUE(o.TotalAmount) OVER (
        PARTITION BY o.EmployeeID ORDER BY o.OrderDate
    ) AS FirstOrderAmount,
    LAST_VALUE(o.TotalAmount) OVER (
        PARTITION BY o.EmployeeID ORDER BY o.OrderDate
    ) AS LastValueDefaultFrame,
    LAST_VALUE(o.TotalAmount) OVER (
        PARTITION BY o.EmployeeID ORDER BY o.OrderDate
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS MostRecentOrderAmount,
    AVG(o.TotalAmount) OVER (
        PARTITION BY o.EmployeeID ORDER BY o.OrderDate
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS MovingAvg2Orders
FROM Orders AS o
ORDER BY o.EmployeeID, o.OrderDate;

/* ------------------------------------------------------------
   Bonus: why LastValueDefaultFrame above is almost always wrong.
   Without an explicit ROWS/RANGE clause, LAST_VALUE (like every
   window aggregate that has an ORDER BY) defaults to
   RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- so "last"
   just means "the current row", not the final row of the
   partition. MostRecentOrderAmount fixes this by explicitly
   extending the frame to the end of the partition
   (CURRENT ROW ... UNBOUNDED FOLLOWING).
   ------------------------------------------------------------ */

-- ------------------------------------------------------------
-- Expected result: Employee 3 (Reza Karimi) has 3 orders in date
--   order: 2,500,000 / 1,800,000 / 750,000.
--   FirstOrderAmount     = 2,500,000 for all 3 rows.
--   LastValueDefaultFrame just repeats each row's own TotalAmount
--     (2,500,000 / 1,800,000 / 750,000) -- this is the trap.
--   MostRecentOrderAmount = 750,000 for all 3 rows (the true last order).
--   MovingAvg2Orders      = 2,500,000 / 2,150,000 / 1,275,000.
--   Employee 6 (Neda Sadeghi) has only one order (3,000,000), so
--   all four computed columns simply equal 3,000,000 for her.
-- ------------------------------------------------------------
