/* ============================================================
   Exercise 08 - NTILE: splitting employees into salary
   quartiles
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Split all employees into 4 roughly equal-sized groups
   (quartiles) based on salary, from highest to lowest.
   ============================================================ */

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    NTILE(4) OVER (ORDER BY Salary DESC) AS SalaryQuartile
FROM Employees
ORDER BY SalaryQuartile, Salary DESC;

/* ------------------------------------------------------------
   Bonus: use NTILE as a simple pagination tool -- split all
   employees (ordered by EmployeeID) into pages of a chosen
   size, then show only "page 2".
   ------------------------------------------------------------ */
WITH PagedEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Salary,
        NTILE(4) OVER (ORDER BY EmployeeID) AS PageNumber
    FROM Employees
)
SELECT EmployeeID, FirstName, LastName, Salary
FROM PagedEmployees
WHERE PageNumber = 2
ORDER BY EmployeeID;

-- ------------------------------------------------------------
-- Expected result: with 10 employees split into NTILE(4), the
--   groups will have sizes 3, 3, 2, 2 (NTILE distributes any
--   remainder to the earliest groups first). SalaryQuartile = 1
--   contains the 3 highest-paid employees.
-- ------------------------------------------------------------