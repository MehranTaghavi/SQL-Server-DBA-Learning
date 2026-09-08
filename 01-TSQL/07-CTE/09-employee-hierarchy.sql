/* ============================================================
   Exercise 08 - Recursive CTE: employee hierarchy
   Find every subordinate of Reza Karimi, including indirect
   subordinates, with Reza at level 0.
   ============================================================ */

WITH OrgChartCTE AS
(
    -- Anchor: Reza Karimi at level 0
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        ManagerID,
        0 AS EmployeeLevel
    FROM Employees
    WHERE FirstName = 'Reza' AND LastName = 'Karimi'

    UNION ALL

    -- Recursive member: direct reports of the current result
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        o.EmployeeLevel + 1
    FROM Employees AS e
    JOIN OrgChartCTE AS o ON e.ManagerID = o.EmployeeID
)
SELECT EmployeeID, FirstName, LastName, EmployeeLevel
FROM OrgChartCTE
ORDER BY EmployeeLevel, EmployeeID;
