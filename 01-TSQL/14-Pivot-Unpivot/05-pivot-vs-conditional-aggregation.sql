/* ============================================================
   05-pivot-vs-conditional-aggregation.sql
   ============================================================
   The same crosstab can be built WITHOUT the PIVOT keyword, using
   SUM(CASE WHEN ...) -- "conditional aggregation". Many
   developers prefer it because it is more flexible: you can mix
   different aggregates in one query (e.g. SUM and COUNT), apply
   different conditions per column, and choose the default for
   empty cells directly (ELSE 0).
   Run 00-setup.sql first.
   ============================================================ */

SELECT
    Region,
    SUM(CASE WHEN SalesQuarter = 'Q1' THEN Amount ELSE 0 END) AS Q1,
    SUM(CASE WHEN SalesQuarter = 'Q2' THEN Amount ELSE 0 END) AS Q2,
    SUM(CASE WHEN SalesQuarter = 'Q3' THEN Amount ELSE 0 END) AS Q3,
    SUM(CASE WHEN SalesQuarter = 'Q4' THEN Amount ELSE 0 END) AS Q4,
    COUNT(*) AS SalesCount
FROM Sales
GROUP BY Region
ORDER BY Region;

-- ------------------------------------------------------------
-- Expected result: 2 rows.
--     East | 150.00 | 150.00 | 120.00 | 200.00 | 5
--     West |  80.00 |  90.00 |   0.00 | 110.00 | 3
--   Same numbers as 02-pivot-null-handling.sql, plus a SalesCount
--   column that a single PIVOT cannot produce, since PIVOT allows
--   only one aggregate per operation.
--
--   Limitation shared by BOTH approaches: the list of columns
--   (Q1..Q4) is fixed in the query text. If the set of values is
--   not known in advance, the column list must be built with
--   dynamic SQL (see 09-Stored-Procedures/Dynamic-SQL-Concept.md).
-- ------------------------------------------------------------
