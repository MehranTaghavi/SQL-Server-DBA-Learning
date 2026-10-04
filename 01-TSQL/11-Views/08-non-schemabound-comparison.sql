/* ============================================================
   08-non-schemabound-comparison.sql
   ============================================================
   This file is fully self-contained -- it builds and drops its
   own throwaway table, so it never touches Employees/Departments.

   Goal: show what happens WITHOUT SCHEMABINDING. Unlike
   07-schemabinding-protection.sql's Part A, dropping a column a
   plain view depends on is NOT blocked here -- it succeeds
   immediately, and the view only breaks later, the next time
   someone actually queries it.
   ============================================================ */

IF OBJECT_ID('dbo.vw_Demo_InventoryNormal', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Demo_InventoryNormal;
IF OBJECT_ID('dbo.Demo_Inventory', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Inventory;
GO

CREATE TABLE dbo.Demo_Inventory (
    ProductID   INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price       DECIMAL(10,2)
);
INSERT INTO dbo.Demo_Inventory VALUES (1, 'Widget', 19.99);
GO

-- No WITH SCHEMABINDING this time.
CREATE VIEW dbo.vw_Demo_InventoryNormal AS
SELECT ProductID, ProductName, Price
FROM dbo.Demo_Inventory;
GO

-- This succeeds immediately -- nothing stops it, because the
-- view isn't schemabound.
ALTER TABLE dbo.Demo_Inventory DROP COLUMN Price;

-- The break only shows up now, when the view is actually used:
SELECT * FROM dbo.vw_Demo_InventoryNormal;

-- ------------------------------------------------------------
-- Expected result: the ALTER TABLE ... DROP COLUMN Price runs
--   with no error or warning at all. The final SELECT is what
--   fails, with "Invalid column name 'Price'." -- the view
--   object still exists, but is now broken, and SQL Server had
--   no way to warn you earlier. Compare this with
--   07-schemabinding-protection.sql's Part A, where the
--   equivalent DROP COLUMN was rejected immediately, at the
--   moment it was attempted, before anything could break.
-- ------------------------------------------------------------