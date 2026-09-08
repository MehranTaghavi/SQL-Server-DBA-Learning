CREATE TABLE #ModifyEmployees (EmployeeID int, Department varchar(50), Salary int);
CREATE TABLE #ModifyRaises (Department varchar(50), RaisePercent decimal(5,2));
INSERT INTO #ModifyEmployees VALUES (1, 'IT', 7000), (2, 'HR', 6500);
INSERT INTO #ModifyRaises VALUES ('IT', 10), ('HR', 5);
UPDATE e SET Salary = CAST(e.Salary * (1 + r.RaisePercent / 100) AS int)
FROM #ModifyEmployees AS e JOIN #ModifyRaises AS r ON r.Department = e.Department;
SELECT * FROM #ModifyEmployees;
