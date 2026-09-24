/* ============================================================
   Exercise 03 - INTERSECT: Find employees who work in BOTH
                 HQ and Branch locations
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ

INTERSECT

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch;
