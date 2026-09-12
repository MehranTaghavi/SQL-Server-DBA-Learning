/* ============================================================
   Exercise 06 - LAG / LEAD: previous and next order amount
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: For every order, show the amount of that same
   employee's previous order and next order (ordered by date),
   without using a self join.
   ============================================================ */

SELECT
    o.OrderID,
    o.EmployeeID,
    o.OrderDate,
    o.TotalAmount,
    LAG(o.TotalAmount)  OVER (PARTITION BY o.EmployeeID ORDER BY o.OrderDate) AS PreviousOrderAmount,
    LEAD(o.TotalAmount) OVER (PARTITION BY o.EmployeeID ORDER BY o.OrderDate) AS NextOrderAmount
FROM Orders AS o
ORDER BY o.EmployeeID, o.OrderDate;

/* ------------------------------------------------------------
   Bonus: same query, but using the optional "default" argument
   so the first/last order of each employee shows 0 instead of
   NULL when there is no previous/next order.
   ------------------------------------------------------------ */
SELECT
    o.OrderID,
    o.EmployeeID,
    o.OrderDate,
    o.TotalAmount,
    LAG(o.TotalAmount, 1, 0)  OVER (PARTITION BY o.EmployeeID ORDER BY o.OrderDate) AS PreviousOrderAmount,
    LEAD(o.TotalAmount, 1, 0) OVER (PARTITION BY o.EmployeeID ORDER BY o.OrderDate) AS NextOrderAmount
FROM Orders AS o
ORDER BY o.EmployeeID, o.OrderDate;

-- ------------------------------------------------------------
-- Expected result: Employee 3 (Reza Karimi) has 3 orders, so his
--   middle order shows both a PreviousOrderAmount and a
--   NextOrderAmount. Employees 5 and 6 each have 2 orders, so
--   their first row has PreviousOrderAmount = NULL and their
--   second row has NextOrderAmount = NULL (or 0, in the bonus
--   query). Employees with no orders at all do not appear here,
--   because Orders -- not Employees -- is the driving table.
-- ------------------------------------------------------------