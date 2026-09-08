CREATE TABLE #ModifyEmployees (EmployeeID int, FirstName varchar(50), Department varchar(50), Salary int);
INSERT INTO #ModifyEmployees
SELECT EmployeeID, FirstName, Department, Salary
FROM dbo.Employees
WHERE Salary >= 7000;
SELECT * FROM #ModifyEmployees;
