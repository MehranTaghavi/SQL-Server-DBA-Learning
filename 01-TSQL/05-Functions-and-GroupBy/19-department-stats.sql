-- =============================================
-- Exercise 19: Full statistics for each department
-- =============================================
-- Goal: show every statistic for each department with clear column names

SELECT 
    Department AS DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AvgSalary,
    MAX(Salary) AS MaxSalary,
    MIN(Salary) AS MinSalary,
    SUM(Salary) AS TotalSalary,
    MAX(Salary) - MIN(Salary) AS SalaryRange
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;
