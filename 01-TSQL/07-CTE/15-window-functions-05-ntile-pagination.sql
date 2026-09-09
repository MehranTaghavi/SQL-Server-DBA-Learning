/* ============================================================
   Exercise 15 - Window functions: salary page and quartiles
   Practice NTILE and pagination-style row numbers
   ============================================================ */

WITH SalaryList AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Salary,
        ROW_NUMBER() OVER (ORDER BY Salary DESC, EmployeeID) AS RowNum,
        NTILE(4) OVER (ORDER BY Salary DESC, EmployeeID) AS SalaryQuartile
    FROM Employees
)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    RowNum,
    SalaryQuartile
FROM SalaryList
WHERE RowNum BETWEEN 1 AND 5
ORDER BY RowNum;
