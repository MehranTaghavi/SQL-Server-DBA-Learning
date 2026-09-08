/* ============================================================
   Exercise 03 - CTE with JOIN: total sales for every employee
   ============================================================ */

WITH SalesCTE AS
(
    SELECT EmployeeID, SUM(TotalAmount) AS TotalSales
    FROM Orders
    GROUP BY EmployeeID
)
SELECT
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    ISNULL(s.TotalSales, 0) AS TotalSales
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
LEFT JOIN SalesCTE AS s ON s.EmployeeID = e.EmployeeID
ORDER BY TotalSales DESC;
