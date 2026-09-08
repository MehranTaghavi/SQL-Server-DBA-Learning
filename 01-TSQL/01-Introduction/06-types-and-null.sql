IF OBJECT_ID('dbo.IntroEmployees', 'U') IS NOT NULL DROP TABLE dbo.IntroEmployees;
CREATE TABLE dbo.IntroEmployees (EmployeeID int PRIMARY KEY, FirstName varchar(50), Salary varchar(20), Position varchar(50) NULL);
INSERT INTO dbo.IntroEmployees VALUES (1, 'Ali', '8500', 'Developer'), (2, 'Sara', '7200', NULL);

SELECT EmployeeID, FirstName, CAST(Salary AS decimal(10,2)) AS SalaryNumber,
       TRY_CAST(Salary AS int) AS TrySalary,
       ISNULL(Position, 'Unassigned') AS PositionLabel
FROM dbo.IntroEmployees;

SELECT NULLIF(Salary, '0') AS SalaryOrNull,
       COALESCE(Position, 'Unknown') AS PositionOrDefault
FROM dbo.IntroEmployees;
