/* ============================================================
   Exercise 01 - UNION: Combine employees from both locations
                 (Duplicates are removed automatically)
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ

UNION

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch;
