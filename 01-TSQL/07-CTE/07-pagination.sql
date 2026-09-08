/* ============================================================
   Exercise 06 - Pagination with CTE and ROW_NUMBER
   Page 2, with 3 employees per page, ordered by salary descending
   ============================================================ */

WITH PagedEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Salary,
        ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
    FROM Employees
)
SELECT EmployeeID, FirstName, LastName, Salary
FROM PagedEmployees
WHERE RowNum BETWEEN 4 AND 6
ORDER BY RowNum;
