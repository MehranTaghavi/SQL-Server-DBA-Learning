/* ============================================================
   02-view-with-filter.sql
   ============================================================
   A view's own query can include a WHERE clause too -- so the
   filtering logic itself gets saved as part of the view, not
   just the JOIN. Anyone querying this view only ever sees
   employees who already satisfy the condition below; they don't
   need to know or repeat the salary threshold themselves.
   ============================================================ */

CREATE OR ALTER VIEW vw_HighEarners AS
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > 80000;
GO

SELECT * FROM vw_HighEarners
ORDER BY Salary DESC;

-- ------------------------------------------------------------
-- Expected result: 3 rows -- Mina Jafari (95000), Ali Ahmadi
--   (90000), Reza Kamali (85000). Sara Nouri (75000) and Nima
--   Karimi (70000) never appear here, because the WHERE clause
--   is baked into the view itself, not something the caller
--   has to add.
-- ------------------------------------------------------------