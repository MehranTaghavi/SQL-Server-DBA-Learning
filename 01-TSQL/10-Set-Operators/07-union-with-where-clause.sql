/* ============================================================
   Exercise 07 - UNION with Filters: Get a distinct list of 
                 all 'IT' department employees across the company
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ
WHERE Department = 'IT'

UNION

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch
WHERE Department = 'IT';
