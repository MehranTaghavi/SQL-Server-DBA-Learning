/* ============================================================
   Exercise 05 - EXCEPT: Find employees who work ONLY in the
                 Branch and NOT in HQ (Reverse order)
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch

EXCEPT

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ;
