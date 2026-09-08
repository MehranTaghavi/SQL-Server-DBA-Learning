/* ============================================================
   Exercise 07 - Recursive CTE: generate a date series
   ============================================================ */

WITH DateSeriesCTE AS
(
    -- Anchor: starting point
    SELECT CAST('2023-01-01' AS DATE) AS DateValue

    UNION ALL

    -- Recursive member: add one day until the end date
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSeriesCTE
    WHERE DateValue < '2023-01-10'
)
SELECT DateValue
FROM DateSeriesCTE
OPTION (MAXRECURSION 100);
