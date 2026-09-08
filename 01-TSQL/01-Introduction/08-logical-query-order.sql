SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL
GROUP BY Department
HAVING AVG(Salary) > 6000
ORDER BY AverageSalary DESC;
