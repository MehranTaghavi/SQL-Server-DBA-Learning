/* ============================================================
   08-multi-step-report.sql
   ============================================================
   Building a report in STEPS, each step stored in its own temp
   table. Compared with one giant query, every step can be run,
   checked and debugged on its own.

     Step 1: total orders and amount per employee
     Step 2: label each employee with a tier (Gold / Silver /
             Bronze) based on the total
     Step 3: final report -- ALL employees, including those with
             no orders at all
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #OrderTotals;
DROP TABLE IF EXISTS #Tiered;
GO

-- Step 1
SELECT
    EmployeeID,
    COUNT(*)    AS OrderCount,
    SUM(Amount) AS TotalAmount
INTO #OrderTotals
FROM Orders
GROUP BY EmployeeID;

-- Step 2. The CAST gives Tier room for the longest label we will
-- use in step 3 (see the note under Expected result).
SELECT
    EmployeeID,
    OrderCount,
    TotalAmount,
    CAST(
        CASE
            WHEN TotalAmount >= 3000 THEN 'Gold'
            WHEN TotalAmount >= 1000 THEN 'Silver'
            ELSE 'Bronze'
        END AS VARCHAR(10)
    ) AS Tier
INTO #Tiered
FROM #OrderTotals;

-- Step 3
SELECT
    e.FirstName,
    e.LastName,
    ISNULL(t.OrderCount, 0)  AS OrderCount,
    ISNULL(t.TotalAmount, 0) AS TotalAmount,
    ISNULL(t.Tier, 'No orders') AS Tier
FROM Employees AS e
LEFT JOIN #Tiered AS t ON t.EmployeeID = e.EmployeeID
ORDER BY ISNULL(t.TotalAmount, 0) DESC, e.LastName;

DROP TABLE #OrderTotals;
DROP TABLE #Tiered;

-- ------------------------------------------------------------
-- Expected result: 8 rows.
--     Reza    Kamali   2  4000.00  Gold
--     Ali     Ahmadi   3  3050.00  Gold
--     Neda    Sadeghi  1  1300.00  Silver
--     Mina    Jafari   1   800.00  Bronze
--     Nima    Karimi   1   700.00  Bronze
--     Zahra   Alavi    0     0.00  No orders
--     Sara    Nouri    0     0.00  No orders
--     Hossein Razavi   0     0.00  No orders
--   (the last three have no rows in Orders; the LEFT JOIN keeps
--   them and ISNULL fills in the zeros and the label.)
--
-- Note: ISNULL returns the data type of its FIRST argument. If Tier
--   had stayed VARCHAR(6) (the length of 'Silver'/'Bronze'), the
--   replacement 'No orders' would have been silently cut to
--   'No ord'. That is why step 2 casts Tier to VARCHAR(10).
-- ------------------------------------------------------------
