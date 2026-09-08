CREATE TABLE #ModifyEmployees (EmployeeID int, FirstName varchar(50));
INSERT INTO #ModifyEmployees VALUES (1, 'Ali'), (2, 'Sara'), (3, 'Neda');
DELETE FROM #ModifyEmployees WHERE EmployeeID = 3;
SELECT * FROM #ModifyEmployees;
TRUNCATE TABLE #ModifyEmployees;
SELECT COUNT(*) AS RemainingRows FROM #ModifyEmployees;
