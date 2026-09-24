/* ============================================================
   Exercise 09 - Advanced Combinations: Find employees who work
                 in strictly ONE location (Symmetric Difference)
   ============================================================ */

(SELECT EmployeeID, FirstName, LastName FROM Employees_HQ
 UNION
 SELECT EmployeeID, FirstName, LastName FROM Employees_Branch)

EXCEPT

(SELECT EmployeeID, FirstName, LastName FROM Employees_HQ
 INTERSECT
 SELECT EmployeeID, FirstName, LastName FROM Employees_Branch);
