/* ============================================================
   Exercise 13 - Window functions: previous order amount
   Practice LAG
   ============================================================ */

SELECT
    OrderID,
    EmployeeID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount, 1, 0) OVER (
        PARTITION BY EmployeeID
        ORDER BY OrderDate, OrderID
    ) AS PreviousOrderAmount
FROM Orders
ORDER BY EmployeeID, OrderDate, OrderID;
