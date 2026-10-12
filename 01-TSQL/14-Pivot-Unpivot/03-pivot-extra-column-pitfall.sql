/* ============================================================
   03-pivot-extra-column-pitfall.sql
   ============================================================
   THE classic PIVOT mistake. PIVOT silently GROUPS BY every
   column of the source that is not the aggregated column and not
   the pivoted column. Pass it the whole table, and SaleID -- a
   unique value per row -- becomes a grouping column, so nothing
   gets combined.
   Run 00-setup.sql first.
   ============================================================ */

-- WRONG: the source includes SaleID.
SELECT *
FROM (
    SELECT SaleID, Region, SalesQuarter, Amount
    FROM Sales
) AS src
PIVOT (
    SUM(Amount)
    FOR SalesQuarter IN (Q1, Q2, Q3, Q4)
) AS pvt
ORDER BY SaleID;

-- RIGHT: select ONLY the columns you need in the derived table.
SELECT *
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
-- Expected result:
--   WRONG query: 8 rows (one per SaleID), each with exactly ONE
--     quarter filled in and the other three NULL -- no aggregation
--     happened at all, because every row is its own group.
--   RIGHT query: 2 rows (East, West) -- the result from
--     01-pivot-basic.sql.
--   Rule of thumb: the derived table passed to PIVOT should
--   contain exactly three kinds of columns -- the grouping
--   column(s) you want as row labels, the pivoted column, and the
--   aggregated column. Nothing else.
-- ------------------------------------------------------------
