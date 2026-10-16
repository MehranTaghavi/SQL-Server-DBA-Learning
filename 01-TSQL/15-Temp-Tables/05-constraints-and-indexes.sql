/* ============================================================
   05-constraints-and-indexes.sql
   ============================================================
   Because a temp table is a real table, it can have a PRIMARY
   KEY, DEFAULT and CHECK constraints, and indexes -- exactly like
   a permanent one. Indexes are worth adding when you will filter
   or join on the temp table repeatedly.
   Run 00-setup.sql first.
   ============================================================ */

DROP TABLE IF EXISTS #Staff;
GO

CREATE TABLE #Staff (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    Salary     DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    Status     VARCHAR(10)   NOT NULL DEFAULT 'Active'
);

-- Status is not listed, so the DEFAULT fills it in:
INSERT INTO #Staff (EmployeeID, FirstName, Salary)
SELECT EmployeeID, FirstName, Salary
FROM Employees;

-- The CHECK constraint rejects a bad row:
BEGIN TRY
    INSERT INTO #Staff (EmployeeID, FirstName, Salary) VALUES (99, 'Bad', -5);
END TRY
BEGIN CATCH
    PRINT 'CHECK constraint blocked the row: ' + ERROR_MESSAGE();
END CATCH;

CREATE NONCLUSTERED INDEX IX_Staff_Salary ON #Staff (Salary);

SELECT Status, COUNT(*) AS Cnt FROM #Staff GROUP BY Status;

SELECT i.type_desc AS IndexType, i.is_primary_key AS IsPrimaryKey
FROM tempdb.sys.indexes AS i
WHERE i.object_id = OBJECT_ID('tempdb..#Staff')
ORDER BY i.index_id;

DROP TABLE #Staff;

-- ------------------------------------------------------------
-- Expected result:
--   Messages tab : "CHECK constraint blocked the row: The INSERT
--                   statement conflicted with the CHECK constraint..."
--   First SELECT : Active | 8   (the DEFAULT applied to all 8 rows;
--                   the invalid row was never inserted)
--   Second SELECT: 2 rows --
--                   CLUSTERED    | 1   (the PRIMARY KEY)
--                   NONCLUSTERED | 0   (IX_Staff_Salary)
--
-- Tip: do NOT give temp-table constraints explicit names
--   (CONSTRAINT PK_Staff ...). Constraint names must be unique
--   across tempdb, so two sessions running the same script would
--   collide. Leave them unnamed and SQL Server generates a unique
--   name for each session.
-- ------------------------------------------------------------
