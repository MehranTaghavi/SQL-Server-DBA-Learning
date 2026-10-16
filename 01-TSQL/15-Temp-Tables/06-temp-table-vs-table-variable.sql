/* ============================================================
   06-temp-table-vs-table-variable.sql
   ============================================================
   A table variable (DECLARE @t TABLE (...)) looks similar but is
   a different tool:

                     #temp table           @table variable
   Scope             session / procedure   the single batch only
   Transactions      rolled back with the  NOT affected by
                     transaction           ROLLBACK
   Statistics        yes                   no (optimizer guesses)
   Indexes after     yes (CREATE INDEX)    only declared inline
   creation
   Typical use       larger / reused       small row counts,
                     intermediate sets     simple logic

   The ROLLBACK difference is the one you can see directly.
   Run this whole file as ONE batch (select everything, execute).
   ============================================================ */

DROP TABLE IF EXISTS #TempTable;
GO

DECLARE @TableVar TABLE (Id INT);
CREATE TABLE #TempTable (Id INT);

BEGIN TRANSACTION;
    INSERT INTO @TableVar (Id) VALUES (1);
    INSERT INTO #TempTable (Id) VALUES (1);
ROLLBACK TRANSACTION;

SELECT
    (SELECT COUNT(*) FROM @TableVar)  AS TableVariableRows,
    (SELECT COUNT(*) FROM #TempTable) AS TempTableRows;

DROP TABLE #TempTable;

-- ------------------------------------------------------------
-- Expected result: TableVariableRows = 1, TempTableRows = 0.
--   Both inserts happened inside the same transaction, and the
--   transaction was rolled back. The temp table is transactional,
--   so its row vanished. The table variable ignores transactions,
--   so its row survived -- useful when you WANT data to outlive a
--   rollback (for example, to log what went wrong), a surprise
--   when you don't.
-- ------------------------------------------------------------
