/* ============================================================
   Exercise 01 - ROW_NUMBER: Company-wide salary ranking
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Assign a unique sequential number to every employee
   based on salary, from highest to lowest, regardless of
   department.
   ============================================================ */

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees
ORDER BY SalaryRank;