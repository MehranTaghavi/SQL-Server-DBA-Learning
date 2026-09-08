IF OBJECT_ID('dbo.IntroDepartments', 'U') IS NOT NULL DROP TABLE dbo.IntroDepartments;
IF OBJECT_ID('dbo.IntroEmployeesKeys', 'U') IS NOT NULL DROP TABLE dbo.IntroEmployeesKeys;
CREATE TABLE dbo.IntroDepartments (DepartmentID int PRIMARY KEY, DepartmentName varchar(50) NOT NULL UNIQUE);
CREATE TABLE dbo.IntroEmployeesKeys (
    EmployeeID int PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    DepartmentID int NOT NULL REFERENCES dbo.IntroDepartments(DepartmentID)
);
INSERT INTO dbo.IntroDepartments VALUES (1, 'IT'), (2, 'HR');
INSERT INTO dbo.IntroEmployeesKeys VALUES (1, 'Ali', 1), (2, 'Sara', 2);
SELECT e.EmployeeID, e.FirstName, d.DepartmentName
FROM dbo.IntroEmployeesKeys AS e
JOIN dbo.IntroDepartments AS d ON d.DepartmentID = e.DepartmentID;
