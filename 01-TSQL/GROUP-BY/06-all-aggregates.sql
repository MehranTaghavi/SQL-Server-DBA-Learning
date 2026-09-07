-- =============================================
-- تمرین ۶: همه توابع تجمعی
-- =============================================
-- هدف: نمایش همه آمارهای هر بخش

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary,
    MAX(Salary) as MaxSalary,
    MIN(Salary) as MinSalary,
    SUM(Salary) as TotalSalary
FROM Employees
GROUP BY Department
ORDER BY Department;