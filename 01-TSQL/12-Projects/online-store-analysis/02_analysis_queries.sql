/*=============================================================================
  Project: Online Store Sales Analysis (T-SQL Portfolio Project)
  File:    02_analysis_queries.sql
  Author:  Mehran Taghavi Afkham
  Purpose: A set of business-style analysis queries against the
           OnlineStoreSample database created by 01_schema_and_data.sql.
           Each query answers a realistic business question and
           demonstrates a specific T-SQL technique (JOIN, Subquery,
           CTE, Window Functions).

  Run 01_schema_and_data.sql first, then run this file against the
  same OnlineStoreSample database.
=============================================================================*/

USE OnlineStoreSample;
GO

/*=============================================================================
  Query 1 — JOINs
  Business question: "Give me a full order detail list showing customer
  name, product name, quantity, and line total, for every order."
  Technique: INNER JOIN across four tables.
=============================================================================*/
SELECT
    o.OrderID,
    c.FullName                         AS CustomerName,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice         AS LineTotal,
    o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers  AS c  ON c.CustomerID = o.CustomerID
INNER JOIN dbo.OrderItems AS oi ON oi.OrderID   = o.OrderID
INNER JOIN dbo.Products   AS p  ON p.ProductID  = oi.ProductID
ORDER BY o.OrderDate, o.OrderID;
GO


/*=============================================================================
  Query 2 — Subquery
  Business question: "Which customers have spent more than the average
  total spend across all customers?"
  Technique: Correlated aggregation + subquery in the WHERE/HAVING clause.
=============================================================================*/
SELECT
    c.CustomerID,
    c.FullName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM dbo.Customers AS c
INNER JOIN dbo.Orders     AS o  ON o.CustomerID = c.CustomerID
INNER JOIN dbo.OrderItems AS oi ON oi.OrderID   = o.OrderID
GROUP BY c.CustomerID, c.FullName
HAVING SUM(oi.Quantity * oi.UnitPrice) >
(
    -- Average total spend per customer, computed as its own subquery
    SELECT AVG(CustomerTotal.TotalSpent)
    FROM
    (
        SELECT o2.CustomerID, SUM(oi2.Quantity * oi2.UnitPrice) AS TotalSpent
        FROM dbo.Orders AS o2
        INNER JOIN dbo.OrderItems AS oi2 ON oi2.OrderID = o2.OrderID
        GROUP BY o2.CustomerID
    ) AS CustomerTotal
)
ORDER BY TotalSpent DESC;
GO


/*=============================================================================
  Query 3 — CTE (Common Table Expression)
  Business question: "What is the total revenue per month, and how does
  each month compare to the previous one?"
  Technique: CTE to first compute monthly revenue, then a second pass
  to compute month-over-month change, keeping the logic readable.
=============================================================================*/
WITH MonthlyRevenue AS
(
    SELECT
        DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1) AS SalesMonth,
        SUM(oi.Quantity * oi.UnitPrice)                          AS Revenue
    FROM dbo.Orders AS o
    INNER JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
    GROUP BY DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)
)
SELECT
    SalesMonth,
    Revenue,
    Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS ChangeFromPrevMonth
FROM MonthlyRevenue
ORDER BY SalesMonth;
GO


/*=============================================================================
  Query 4 — Window Functions
  Business question: "Rank customers by total spend within each month,
  and show the top 2 spenders per month, plus a running total of
  overall revenue over time."
  Technique: RANK() OVER (PARTITION BY ...) and SUM() OVER (ORDER BY ...)
=============================================================================*/
WITH MonthlyCustomerSpend AS
(
    SELECT
        DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1) AS SalesMonth,
        c.CustomerID,
        c.FullName,
        SUM(oi.Quantity * oi.UnitPrice) AS MonthlySpend
    FROM dbo.Orders AS o
    INNER JOIN dbo.Customers  AS c  ON c.CustomerID = o.CustomerID
    INNER JOIN dbo.OrderItems AS oi ON oi.OrderID   = o.OrderID
    GROUP BY DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1),
             c.CustomerID, c.FullName
)
SELECT
    SalesMonth,
    FullName,
    MonthlySpend,
    RANK() OVER (PARTITION BY SalesMonth ORDER BY MonthlySpend DESC) AS SpendRankInMonth,
    SUM(MonthlySpend) OVER (ORDER BY SalesMonth
                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalRevenue
FROM MonthlyCustomerSpend
ORDER BY SalesMonth, SpendRankInMonth;
-- To see only the top 2 spenders per month, wrap this query in a CTE/subquery
-- and filter WHERE SpendRankInMonth <= 2.
GO