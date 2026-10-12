/* ============================================================
   00-setup.sql
   ============================================================
   Creates the Sales table used by every file in this folder.
   Two details are deliberate:
     - East / Q1 has TWO rows (100 and 50), so PIVOT has
       something to aggregate.
     - West has NO Q3 row at all, so the pivoted result
       contains a genuine NULL.
   Run this once before any of the other scripts here.
   ============================================================ */

DROP TABLE IF EXISTS Sales;
GO

CREATE TABLE Sales (
    SaleID       INT PRIMARY KEY,
    Region       VARCHAR(20),
    SalesQuarter VARCHAR(2),
    Amount       DECIMAL(10,2)
);
GO

INSERT INTO Sales (SaleID, Region, SalesQuarter, Amount) VALUES
(1, 'East', 'Q1', 100),
(2, 'East', 'Q1',  50),
(3, 'East', 'Q2', 150),
(4, 'East', 'Q3', 120),
(5, 'East', 'Q4', 200),
(6, 'West', 'Q1',  80),
(7, 'West', 'Q2',  90),
(8, 'West', 'Q4', 110);
GO
