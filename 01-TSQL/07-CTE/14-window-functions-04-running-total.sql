/* ============================================================
   Exercise 14 - Window functions: running total of orders
   Practice SUM with ROWS BETWEEN
   ============================================================ */

SELECT
    OrderID,
    EmployeeID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        PARTITION BY EmployeeID
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Orders
ORDER BY EmployeeID, OrderDate, OrderID;
