/* ============================================================
   04-global-temp-tables.sql
   ============================================================
   A name starting with TWO hash signs (##) makes the temp table
   GLOBAL: every session on the server can see it, not just the
   one that created it. It is dropped when the session that
   created it ends AND no other session is still using it.

   Global temp tables are rarely the right tool -- any session
   can read, change or drop them, and two sessions picking the
   same name collide. They are shown here so you recognise them.
   Fully self-contained.
   ============================================================ */

DROP TABLE IF EXISTS ##SharedDemo;
GO

CREATE TABLE ##SharedDemo (
    Id   INT,
    Note VARCHAR(50)
);

INSERT INTO ##SharedDemo (Id, Note) VALUES (1, 'Visible to every session');

SELECT Id, Note FROM ##SharedDemo;

-- ------------------------------------------------------------
-- Try it yourself: open a SECOND query window in SSMS (a new
-- connection) while this one stays open, and run:
--     SELECT Id, Note FROM ##SharedDemo;
-- The row appears there too. With a single-# table it would fail
-- with "Invalid object name".
--
-- Cleanup (run it AFTER the second-window test):
--     DROP TABLE ##SharedDemo;
--
-- Expected result (this window): 1 row -- Id 1, 'Visible to every
--   session'.
-- ------------------------------------------------------------
