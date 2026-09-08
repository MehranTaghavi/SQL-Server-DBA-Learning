CREATE TABLE #ModifyTarget (EmployeeID int PRIMARY KEY, FirstName varchar(50), Salary int);
CREATE TABLE #ModifySource (EmployeeID int PRIMARY KEY, FirstName varchar(50), Salary int);
INSERT INTO #ModifyTarget VALUES (1, 'Ali', 8500), (2, 'Sara', 7200);
INSERT INTO #ModifySource VALUES (1, 'Ali', 9000), (3, 'Neda', 8300);
MERGE #ModifyTarget AS target
USING #ModifySource AS source ON source.EmployeeID = target.EmployeeID
WHEN MATCHED THEN UPDATE SET FirstName = source.FirstName, Salary = source.Salary
WHEN NOT MATCHED BY TARGET THEN INSERT (EmployeeID, FirstName, Salary) VALUES (source.EmployeeID, source.FirstName, source.Salary);
SELECT * FROM #ModifyTarget;
