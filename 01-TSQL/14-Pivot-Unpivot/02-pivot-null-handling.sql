/* ============================================================
   02-pivot-null-handling.sql
   ============================================================
   A pivoted cell with no source rows is NULL, not 0. For reports
   you usually want 0 -- wrap each pivoted column in ISNULL.
   Run 00-setup.sql first.
   ============================================================ */

SELECT
    Region,
    ISNULL(Q1, 0) AS Q1,
    ISNULL(Q2, 0) AS Q2,
    ISNULL(Q3, 0) AS Q3,
    ISNULL(Q4, 0) AS Q4
FROM (
    SELECT Region, SalesQuarter, Amount
    FROM Sales
) AS src
PIVOT (
    SUM(Amount)
    FOR SalesQuarter IN (Q1, Q2, Q3, Q4)
) AS pvt
ORDER BY Region;

-- ------------------------------------------------------------
-- Expected result: the same 2 rows as 01-pivot-basic.sql, but
--   West's missing quarter now shows 0 instead of NULL:
--     East | 150.00 | 150.00 | 120.00 | 200.00
--     West |  80.00 |  90.00 |   0.00 | 110.00
-- ------------------------------------------------------------
