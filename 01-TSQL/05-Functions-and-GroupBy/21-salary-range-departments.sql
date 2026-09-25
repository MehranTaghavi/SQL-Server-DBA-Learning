-- =============================================
-- Exercise 21: Departments with a wide salary spread
-- =============================================
-- Goal: show departments that:
-- 1. Have at least 2 employees
-- 2. Have a gap between their highest and lowest salary greater than 1500
-- 3. Have an average salary of at least 8000

SELECT 
    Department AS DepartmentName,
    COUNT(*) AS EmployeeCount,
    MIN(Salary) AS MinSalary,
    MAX(Salary) AS MaxSalary,
    MAX(Salary) - MIN(Salary) AS SalaryRange,
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING COUNT(*) >= 2
    AND MAX(Salary) - MIN(Salary) > 1500
    AND AVG(Salary) >= 8000
ORDER BY SalaryRange DESC;