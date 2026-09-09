/* ============================================================
   Exercise 11 - Window functions: rank employees by salary
   Practice ROW_NUMBER, RANK, and DENSE_RANK
   ============================================================ */

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC, EmployeeID) AS RowNum,
    RANK()       OVER (ORDER BY Salary DESC) AS SalaryRank,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryDenseRank
FROM Employees
ORDER BY Salary DESC, EmployeeID;
