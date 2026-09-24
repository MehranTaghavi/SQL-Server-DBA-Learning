/* ============================================================
   Exercise 04 - EXCEPT: Find employees who work ONLY in HQ
                 and NOT in the Branch
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ

EXCEPT

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch;
