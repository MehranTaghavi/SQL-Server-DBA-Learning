/* ============================================================
   Exercise 07 - SUM() OVER with a window frame: running total
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: For every order, show a running total of that same
   employee's order amounts, accumulated in date order.
   ============================================================ */

SELECT
    o.OrderID,
    o.EmployeeID,
    o.OrderDate,
    o.TotalAmount,
    SUM(o.TotalAmount) OVER (
        PARTITION BY o.EmployeeID
        ORDER BY o.OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalPerEmployee
FROM Orders AS o
ORDER BY o.EmployeeID, o.OrderDate;

/* ------------------------------------------------------------
   Bonus: a company-wide running total across ALL employees,
   ordered only by date (no PARTITION BY at all).
   ------------------------------------------------------------ */
SELECT
    o.OrderID,
    o.EmployeeID,
    o.OrderDate,
    o.TotalAmount,
    SUM(o.TotalAmount) OVER (
        ORDER BY o.OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CompanyRunningTotal
FROM Orders AS o
ORDER BY o.OrderDate;

-- ------------------------------------------------------------
-- Expected result: for employee 3 (three orders of 2,500,000 /
--   1,800,000 / 750,000, in date order), RunningTotalPerEmployee
--   goes 2,500,000 -> 4,300,000 -> 5,050,000. The bonus query's
--   CompanyRunningTotal keeps growing across every employee's
--   orders combined, in pure date order.
-- ------------------------------------------------------------