/* ============================================================
   01-pivot-basic.sql
   ============================================================
   PIVOT rotates ROWS into COLUMNS: the distinct values of one
   column (here SalesQuarter: Q1..Q4) become column headings, and
   an aggregate fills the cells.

   Three ingredients:
     1. A source query (the derived table) with only the columns
        you need.
     2. An aggregate function (SUM(Amount)) -- the cell value.
     3. FOR <column> IN (...) -- which column's values become
        headings, listed explicitly.
   Run 00-setup.sql first.
   ============================================================ */

SELECT
    Region,
    Q1,
    Q2,
    Q3,
    Q4
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
-- Expected result: 2 rows, one per Region.
--     East | 150.00 | 150.00 | 120.00 | 200.00
--     West |  80.00 |  90.00 |   NULL | 110.00
--   East/Q1 is 150 because PIVOT summed the two Q1 rows (100 + 50).
--   West/Q3 is NULL because no West/Q3 row exists to aggregate.
-- ------------------------------------------------------------
