/* ============================================================
   13-pitfalls.sql
   ============================================================
   Two behaviours that surprise people. Fully self-contained.
   ============================================================ */

DROP TABLE IF EXISTS #Src;
DROP TABLE IF EXISTS #Copy;
DROP TABLE IF EXISTS #CopyNoIdentity;
GO

-- Pitfall 1: a temp table created inside EXEC('...') is gone as soon
-- as the EXEC finishes -- it only lived in the dynamic-SQL scope.
EXEC ('CREATE TABLE #DynCreated (A INT); INSERT INTO #DynCreated VALUES (1);');

SELECT
    CASE WHEN OBJECT_ID('tempdb..#DynCreated') IS NULL
         THEN 'gone' ELSE 'exists' END AS DynCreatedTable;
GO

-- Pitfall 2: SELECT ... INTO copies the IDENTITY property, too.
CREATE TABLE #Src (
    Id   INT IDENTITY(1, 1),
    Name VARCHAR(10) NOT NULL
);
INSERT INTO #Src (Name) VALUES ('a'), ('b');

SELECT Id, Name INTO #Copy FROM #Src;

-- Adding an expression (Id + 0) means the column is no longer a plain
-- identity column, so the property is NOT copied:
SELECT Id + 0 AS Id, Name INTO #CopyNoIdentity FROM #Src;

SELECT
    (SELECT c.is_identity FROM tempdb.sys.columns AS c
     WHERE c.object_id = OBJECT_ID('tempdb..#Copy') AND c.name = 'Id') AS CopyIsIdentity,
    (SELECT c.is_identity FROM tempdb.sys.columns AS c
     WHERE c.object_id = OBJECT_ID('tempdb..#CopyNoIdentity') AND c.name = 'Id') AS CopyNoIdentityIsIdentity;

DROP TABLE #Src;
DROP TABLE #Copy;
DROP TABLE #CopyNoIdentity;

-- ------------------------------------------------------------
-- Expected result:
--   Pitfall 1: DynCreatedTable = 'gone'. (If you need a temp table
--     that dynamic SQL fills, create it OUTSIDE the EXEC first --
--     see 03-scope-and-lifetime.sql, Part A.)
--   Pitfall 2: CopyIsIdentity = 1, CopyNoIdentityIsIdentity = 0.
--     If you later try to INSERT your own Id values into #Copy,
--     SQL Server will refuse unless IDENTITY_INSERT is on.
--
-- Two more to remember (not demonstrated, they need two sessions
--   or a different server setup):
--   - Explicitly named constraints on a temp table collide across
--     sessions (see the tip in 05-constraints-and-indexes.sql).
--   - Temp tables live in tempdb. If tempdb uses a different
--     collation from your database, comparing a text column of your
--     table with a text column of a temp table can raise a collation
--     conflict error.
-- ------------------------------------------------------------