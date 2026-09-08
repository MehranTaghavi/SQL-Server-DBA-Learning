CREATE TABLE #ModifyEmployees (EmployeeID int IDENTITY(1,1), FirstName varchar(50), Department varchar(50), Salary int);
INSERT INTO #ModifyEmployees (FirstName, Department, Salary)
VALUES ('Lina', 'IT', 7600), ('Omid', 'HR', 6800);
SELECT * FROM #ModifyEmployees;
