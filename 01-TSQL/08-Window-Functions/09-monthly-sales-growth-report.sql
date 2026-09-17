/* ============================================================
   Exercise 09 - Monthly Sales Growth Report (CTE + LAG + RANK)
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Build a realistic, BI-style report that shows total
   sales per month, the month-over-month growth percentage, and
   ranks the months by growth -- a report pattern used constantly
   in real sales dashboards. This combines a CTE, GROUP BY
   aggregation, LAG, and RANK all in one query.
   ============================================================ */

-- ------------------------------------------------------------
-- Part A: company-wide monthly sales growth
-- ------------------------------------------------------------
WITH MonthlySales AS
(
    SELECT
        YEAR(o.OrderDate)  AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        SUM(o.TotalAmount) AS TotalSales
    FROM Orders AS o
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
),
MonthlyGrowth AS
(
    SELECT
        SalesYear,
        SalesMonth,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth) AS PreviousMonthSales,
        ROUND(
            (TotalSales - LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth))
            / NULLIF(LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth), 0) * 100.0,
            2
        ) AS GrowthPercent
    FROM MonthlySales
)
SELECT
    SalesYear,
    SalesMonth,
    TotalSales,
    PreviousMonthSales,
    GrowthPercent,
    RANK() OVER (ORDER BY GrowthPercent DESC) AS GrowthRank
FROM MonthlyGrowth
ORDER BY SalesYear, SalesMonth;

-- ------------------------------------------------------------
-- Expected result (Part A):
--   Jan 2023 -> TotalSales 3,400,000 | PreviousMonthSales NULL
--     | GrowthPercent NULL (nothing to compare against).
--   Feb 2023 -> TotalSales 4,800,000 | PreviousMonthSales
--     3,400,000 | GrowthPercent 41.18 | GrowthRank 1 (best month).
--   Mar 2023 -> TotalSales 1,200,000 | PreviousMonthSales
--     4,800,000 | GrowthPercent -75.00 | GrowthRank 3 (worst month).
--   Apr 2023 -> TotalSales   750,000 | PreviousMonthSales
--     1,200,000 | GrowthPercent -37.50 | GrowthRank 2.
--   NULLIF protects the division from a divide-by-zero error if
--   a previous month's total were ever exactly 0.
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- Part B (bonus): the same growth-report pattern, but broken
-- down PER EMPLOYEE instead of company-wide -- exactly what a
-- sales manager would use to spot which rep is trending up or
-- down from one month to the next.
-- ------------------------------------------------------------
WITH MonthlySalesByEmployee AS
(
    SELECT
        o.EmployeeID,
        YEAR(o.OrderDate)  AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        SUM(o.TotalAmount) AS TotalSales
    FROM Orders AS o
    GROUP BY o.EmployeeID, YEAR(o.OrderDate), MONTH(o.OrderDate)
)
SELECT
    e.FirstName,
    e.LastName,
    m.SalesYear,
    m.SalesMonth,
    m.TotalSales,
    LAG(m.TotalSales) OVER (
        PARTITION BY m.EmployeeID ORDER BY m.SalesYear, m.SalesMonth
    ) AS PreviousMonthSales,
    ROUND(
        (m.TotalSales - LAG(m.TotalSales) OVER (
            PARTITION BY m.EmployeeID ORDER BY m.SalesYear, m.SalesMonth
        ))
        / NULLIF(LAG(m.TotalSales) OVER (
            PARTITION BY m.EmployeeID ORDER BY m.SalesYear, m.SalesMonth
        ), 0) * 100.0,
        2
    ) AS GrowthPercent
FROM MonthlySalesByEmployee AS m
INNER JOIN Employees AS e ON e.EmployeeID = m.EmployeeID
ORDER BY e.EmployeeID, m.SalesYear, m.SalesMonth;

-- ------------------------------------------------------------
-- Expected result (Part B):
--   Reza Karimi (EmployeeID 3) has 3 rows: Jan (2,500,000, no
--     previous), Feb (1,800,000, growth -28.00%), Apr (750,000,
--     growth -58.33%).
--   Hossein Ghasemi (EmployeeID 5) has 2 rows: Jan (900,000, no
--     previous), Mar (1,200,000, growth 33.33%).
--   Neda Sadeghi (EmployeeID 6) has 1 row: Feb (3,000,000, no
--     previous -- she only sold in one month).
--   IMPORTANT nuance: LAG here compares against the previous ROW
--   in the partition, not the previous CALENDAR month. Reza has
--   no March order, so his April row is compared against
--   February, not March -- exactly the kind of subtlety a real
--   report needs to account for (e.g. by first generating a
--   complete calendar of months per employee if "no order this
--   month" should count as zero instead of being skipped).
-- ------------------------------------------------------------
