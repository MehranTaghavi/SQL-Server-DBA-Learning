/* ============================================================
   Exercise 06 - UNION ALL with Literals: Add a 'Source' column
                 to track where each record comes from
   ============================================================ */

SELECT EmployeeID, FirstName, LastName, 'Headquarters' AS Location
FROM Employees_HQ

UNION ALL

SELECT EmployeeID, FirstName, LastName, 'Branch Office' AS Location
FROM Employees_Branch;
