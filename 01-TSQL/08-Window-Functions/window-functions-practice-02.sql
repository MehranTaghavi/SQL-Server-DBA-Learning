-- =============================================
-- Window Functions - Practice Set 02
-- Repository: SQL-Server-DBA-Learning
-- Path: 01-TSQL/08-Window-Functions
-- =============================================

-- 1) Number rows within each department by salary descending
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS RowNumInDepartment
FROM Employees;


-- 2) Salary percentile and cumulative distribution (global)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    PERCENT_RANK() OVER (ORDER BY Salary) AS SalaryPercentRank,
    CUME_DIST() OVER (ORDER BY Salary) AS SalaryCumeDist
FROM Employees;


-- 3) Split employees into 4 salary buckets
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    NTILE(4) OVER (ORDER BY Salary DESC) AS SalaryQuartile
FROM Employees;


-- 4) First and last hired employee in each department
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    HireDate,
    FIRST_VALUE(FirstName + ' ' + LastName) OVER (
        PARTITION BY Department
        ORDER BY HireDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS FirstHiredInDepartment,
    LAST_VALUE(FirstName + ' ' + LastName) OVER (
        PARTITION BY Department
        ORDER BY HireDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS LastHiredInDepartment
FROM Employees;


-- 5) Monthly total orders and running monthly total
WITH MonthlyOrders AS (
    SELECT
        DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
        COUNT(*) AS OrdersCount,
        SUM(TotalAmount) AS MonthlySales
    FROM Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT
    OrderMonth,
    OrdersCount,
    MonthlySales,
    SUM(MonthlySales) OVER (
        ORDER BY OrderMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningSales
FROM MonthlyOrders
ORDER BY OrderMonth;


-- 6) Compare each order amount with customer average order amount
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    AVG(TotalAmount) OVER (PARTITION BY CustomerID) AS CustomerAvgOrder,
    TotalAmount - AVG(TotalAmount) OVER (PARTITION BY CustomerID) AS DiffFromCustomerAvg
FROM Orders;


-- 7) Previous and next order amount per customer (time-based)
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PreviousOrderAmount,
    LEAD(TotalAmount) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS NextOrderAmount
FROM Orders;


-- 8) Identify latest order per customer
WITH CustomerOrders AS (
    SELECT
        OrderID,
        CustomerID,
        OrderDate,
        TotalAmount,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate DESC, OrderID DESC
        ) AS rn
    FROM Orders
)
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount
FROM CustomerOrders
WHERE rn = 1
ORDER BY CustomerID;
