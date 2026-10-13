/* ============================================================
   04-unpivot-basic.sql
   ============================================================
   UNPIVOT is the reverse: it rotates COLUMNS into ROWS. Typical
   use: a "wide" table (one column per quarter) that you need in
   "tall" form (one row per region + quarter) for analysis.

   Self-contained: builds its own wide table, SalesWide, by
   pivoting Sales first (so it needs 00-setup.sql run once).
   ============================================================ */

DROP TABLE IF EXISTS SalesWide;
GO

SELECT Region, Q1, Q2, Q3, Q4
INTO SalesWide
FROM (
    SELECT Region, SalesQuarter, Amount
    FROM Sales
) AS src
PIVOT (
    SUM(Amount)
    FOR SalesQuarter IN (Q1, Q2, Q3, Q4)
) AS pvt;
GO

SELECT Region, SalesQuarter, Amount
FROM SalesWide
UNPIVOT (
    Amount
    FOR SalesQuarter IN (Q1, Q2, Q3, Q4)
) AS unp
ORDER BY Region, SalesQuarter;

-- ------------------------------------------------------------
-- Expected result: 7 rows, NOT 8:
--     East | Q1 | 150.00
--     East | Q2 | 150.00
--     East | Q3 | 120.00
--     East | Q4 | 200.00
--     West | Q1 |  80.00
--     West | Q2 |  90.00
--     West | Q4 | 110.00
--   West/Q3 was NULL in the wide table, and UNPIVOT silently
--   DROPS rows whose value is NULL. Also note UNPIVOT is not a
--   perfect inverse of PIVOT: the two East/Q1 rows were already
--   summed into 150 by the earlier PIVOT and cannot be separated
--   again.
-- ------------------------------------------------------------
