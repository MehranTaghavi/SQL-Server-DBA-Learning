/* ============================================================
   01-scalar-function-years-of-service.sql
   ============================================================
   A SCALAR function returns a single value and can be used
   directly inside a SELECT list, a WHERE clause, or anywhere
   else a plain expression could go -- unlike a stored procedure,
   you never EXEC it separately.
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.GetYearsOfService (@HireDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @HireDate, GETDATE());
END;
GO

-- Used directly as a computed column:
SELECT
    FirstName,
    LastName,
    HireDate,
    dbo.GetYearsOfService(HireDate) AS YearsOfService
FROM Employees
ORDER BY YearsOfService DESC;

-- Can also be used in a WHERE clause (see the performance note
-- in 05-scalar-udf-performance-note.sql before relying on this
-- habitually on a large table):
SELECT FirstName, LastName
FROM Employees
WHERE dbo.GetYearsOfService(HireDate) >= 6;

-- ------------------------------------------------------------
-- Expected result (first query): YearsOfService based on today's
--   date. As of October 2026: Reza Kamali (hired 2016) -> 10,
--   Ali Ahmadi (2018) -> 8, Nima Karimi (2019) -> 7, Sara Nouri
--   (2020) -> 6, Mina Jafari (2021) -> 5.
-- Expected result (second query): Reza, Ali, Nima, and Sara (4
--   rows) -- everyone with YearsOfService >= 6.
--
-- Caveat worth knowing: DATEDIFF(YEAR, ...) subtracts calendar
--   YEAR NUMBERS, not full elapsed years. Someone hired on
--   2020-12-28 and someone hired on 2020-01-05 both show the
--   same "YearsOfService" on any given day in a later year, even
--   though one of them has worked almost a full year longer than
--   the other. If you need exact elapsed years, you'd need extra
--   logic comparing month/day too -- intentionally left out here
--   to keep this first example simple.
-- ------------------------------------------------------------
