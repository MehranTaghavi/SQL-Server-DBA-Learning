/* ============================================================
   Exercise 05 - ROW_NUMBER vs RANK vs DENSE_RANK: side by side
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Compare all three ranking functions on the same
   ordering (department headcount) to see how each one handles
   a tie.
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
    ROW_NUMBER() OVER (ORDER BY EmployeeCount DESC) AS RowNum,
    RANK()       OVER (ORDER BY EmployeeCount DESC) AS RankNum,
    DENSE_RANK() OVER (ORDER BY EmployeeCount DESC) AS DenseRankNum
FROM DeptHeadcount
ORDER BY EmployeeCount DESC;