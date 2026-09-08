SELECT Department, SUM(Salary) AS DepartmentPayroll
FROM dbo.Employees
GROUP BY Department;

SELECT FirstName, LastName
FROM dbo.Employees
WHERE Position IS NULL OR Position = 'Developer';
