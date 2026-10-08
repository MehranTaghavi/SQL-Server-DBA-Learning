/* ============================================================
   05-scalar-udf-performance-note.sql
   ============================================================
   This file doesn't have a single "expected result" the way the
   others do -- it's meant to be observed, not just run. The
   tables here are far too small (5 rows) to show a real timing
   difference, but the two queries below let you see the
   STRUCTURAL difference in SSMS regardless of table size.

   Turn on Actual Execution Plan (Ctrl+M) before running both.
   ============================================================ */

-- Query A: filters using the scalar function from 01, inside WHERE.
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE dbo.GetYearsOfService(HireDate) >= 6;

-- Query B: the exact same filter, written as a plain expression
-- instead of a function call.
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= 6;

-- ------------------------------------------------------------
-- What to look for:
--   Both queries return the SAME 4 rows (Reza, Ali, Nima, Sara)
--   -- the function is just a thin wrapper around the same
--   DATEDIFF expression, so the data doesn't differ.
--
--   The difference is in the execution plan. On older SQL Server
--   versions (pre-2019), Query A's plan includes a visible
--   "Scalar Function" cost component and SQL Server effectively
--   evaluates dbo.GetYearsOfService ROW BY ROW -- on a large
--   table, this prevents the optimizer from using an index
--   efficiently on HireDate and can block parallelism entirely.
--   Query B has no such barrier; the optimizer can reason about
--   DATEDIFF directly as part of a single set-based plan.
--
--   SQL Server 2019+ introduced Scalar UDF Inlining, which can
--   automatically rewrite a simple function like
--   dbo.GetYearsOfService into something closer to Query B's plan
--   -- but only when the function meets a specific list of
--   conditions (no error handling, no calls to other
--   non-inlineable objects, and a few others). It's a real
--   improvement, but not a guarantee: it's still worth knowing
--   how to write the inline version yourself, and to check the
--   execution plan rather than assume.
-- ------------------------------------------------------------
