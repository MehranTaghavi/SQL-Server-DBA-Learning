/* ============================================================
   Exercise 03 - RANK: departments ordered by employee headcount
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Rank departments by how many employees they have.
   Departments with the same headcount receive the same rank,
   and RANK() leaves a gap in the sequence right after a tie.
   ============================================================ */

WITH DeptHeadcount AS
(
    SELECT
        d.DepartmentID,
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount
    FROM Departments AS d
    LEFT JOIN Employees AS e ON e.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentID, d.DepartmentName
)
SELECT
    DepartmentName,
    EmployeeCount,
    RANK() OVER (ORDER BY EmployeeCount DESC) AS HeadcountRank
FROM DeptHeadcount
ORDER BY HeadcountRank;