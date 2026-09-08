CREATE TABLE #ModifyStage (EmployeeID int, FirstName varchar(50), Salary int);
INSERT INTO #ModifyStage
SELECT EmployeeID, FirstName, Salary FROM dbo.Employees WHERE Department = 'IT';
UPDATE #ModifyStage SET Salary = Salary + 250 WHERE Salary < 8000;
DELETE FROM #ModifyStage WHERE Salary < 6000;
SELECT * FROM #ModifyStage;
