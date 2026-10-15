/* ============================================================
   03-scope-and-lifetime.sql
   ============================================================
   WHO can see a local temp table, and WHEN does it disappear?
     - It is visible to the session that created it, and to code
       that session runs INSIDE it (dynamic SQL, stored
       procedures it calls).
     - A temp table created INSIDE a stored procedure is dropped
       automatically when that procedure finishes.
     - A temp table created outside is dropped when the session
       ends (or earlier, if you drop it).
   ============================================================ */

DROP TABLE IF EXISTS #Outer;
GO

CREATE TABLE #Outer (Id INT);
INSERT INTO #Outer (Id) VALUES (1), (2);

-- Part A: dynamic SQL runs inside our session, so it can see #Outer.
EXEC ('SELECT COUNT(*) AS VisibleInDynamicSql FROM #Outer');
GO

-- Part B: a temp table created inside a procedure dies with it.
CREATE OR ALTER PROCEDURE dbo.usp_TempScopeDemo
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #InProc (Id INT);
    INSERT INTO #InProc (Id) VALUES (1), (2), (3);
    SELECT COUNT(*) AS InsideProc FROM #InProc;
END;
GO

EXEC dbo.usp_TempScopeDemo;

SELECT
    CASE WHEN OBJECT_ID('tempdb..#InProc') IS NULL
         THEN 'dropped' ELSE 'still exists' END AS AfterProc;
GO

-- Part C: a procedure can read a temp table created by its CALLER.
CREATE OR ALTER PROCEDURE dbo.usp_ReadCallerTemp
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS SeenFromProc FROM #Outer;
END;
GO

EXEC dbo.usp_ReadCallerTemp;
GO

-- Cleanup
DROP PROCEDURE dbo.usp_TempScopeDemo;
DROP PROCEDURE dbo.usp_ReadCallerTemp;
DROP TABLE #Outer;
GO

-- ------------------------------------------------------------
-- Expected result:
--   Part A: VisibleInDynamicSql = 2
--   Part B: InsideProc = 3, then AfterProc = 'dropped'
--           (the procedure's own temp table is already gone)
--   Part C: SeenFromProc = 2 (the procedure sees #Outer, which
--           belongs to the calling session)
-- ------------------------------------------------------------
