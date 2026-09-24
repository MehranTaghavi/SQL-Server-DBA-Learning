/* ============================================================
   Exercise 02 - UNION ALL: Combine all employees 
                 (Duplicates are retained, faster performance)
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_HQ

UNION ALL

SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees_Branch;
