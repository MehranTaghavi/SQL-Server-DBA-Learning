/* ============================================================
   12-cleanup-patterns.sql
   ============================================================
   Three ways to make sure a temp table does not exist before you
   create it (so a script can be re-run), plus how to look at
   which temp tables currently exist. Fully self-contained.
   ============================================================ */

-- Pattern 1: the classic form, works on every SQL Server version.
IF OBJECT_ID('tempdb..#CleanupDemo') IS NOT NULL
    DROP TABLE #CleanupDemo;

CREATE TABLE #CleanupDemo (Id INT);
GO

-- Pattern 2: DROP TABLE IF EXISTS -- shorter; SQL Server 2016+.
DROP TABLE IF EXISTS #CleanupDemo;

CREATE TABLE #CleanupDemo (Id INT);
GO

-- Peek at tempdb: SQL Server stores the table under a padded,
-- unique internal name (your name + underscores + a hex suffix),
-- which is how many sessions can each have their own #CleanupDemo.
SELECT name AS InternalName
FROM tempdb.sys.tables
WHERE name LIKE '#CleanupDemo%';

-- Pattern 3: drop it as soon as you are finished with it.
DROP TABLE #CleanupDemo;

SELECT COUNT(*) AS RemainingCount
FROM tempdb.sys.tables
WHERE name LIKE '#CleanupDemo%';

-- ------------------------------------------------------------
-- Expected result:
--   InternalName   : 1 row, starting with '#CleanupDemo' followed
--                    by many underscores and a hexadecimal number
--   RemainingCount : 0
--
-- Temp tables also disappear on their own (end of session, end of
-- the procedure that created them), but dropping explicitly keeps
-- tempdb tidy and makes scripts safe to re-run in the same window.
-- ------------------------------------------------------------