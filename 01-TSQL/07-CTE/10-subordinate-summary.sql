/* ============================================================
   Exercise 09 - Recursive CTE with aggregation
   Count all direct and indirect subordinates for every employee
   and calculate their combined salary.
   ============================================================ */

WITH SubordinatesCTE AS
(
    -- Anchor: each employee is a hierarchy root at depth 0
    SELECT
        EmployeeID AS ManagerRootID,
        EmployeeID AS SubordinateID,
        Salary AS SubordinateSalary,
        0 AS Depth
    FROM Employees

    UNION ALL

    -- Recursive member: find each employee's descendants
    SELECT
        s.ManagerRootID,
        e.EmployeeID,
        e.Salary,
        s.Depth + 1
    FROM Employees AS e
    JOIN SubordinatesCTE AS s ON e.ManagerID = s.SubordinateID
)
SELECT
    m.EmployeeID,
    m.FirstName,
    m.LastName,
    COUNT(CASE WHEN s.Depth > 0 THEN 1 END) AS TotalSubordinates,
    ISNULL(SUM(CASE WHEN s.Depth > 0 THEN s.SubordinateSalary END), 0) AS SubordinatesSalarySum
FROM Employees AS m
JOIN SubordinatesCTE AS s ON s.ManagerRootID = m.EmployeeID
GROUP BY m.EmployeeID, m.FirstName, m.LastName
ORDER BY TotalSubordinates DESC;
