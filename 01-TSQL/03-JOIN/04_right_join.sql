/* ============================================================
   Exercise 04.4 - RIGHT JOIN
   Topic   : Joins
   Goal    : Keep ALL rows from the right table, even when there
             is no matching row on the left. Unmatched columns
             come back as NULL.
   ============================================================ */

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- ------------------------------------------------------------
-- Table setup (same shape and same sample data as exercises
-- 01 and 02, so this script can be run completely on its own)
-- ------------------------------------------------------------
CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID     INT PRIMARY KEY,
    FirstName      VARCHAR(50) NOT NULL,
    LastName       VARCHAR(50) NOT NULL,
    Salary         DECIMAL(10,2) NOT NULL,
    DepartmentID   INT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
    (1, 'Sales'),
    (2, 'Engineering'),
    (3, 'Human Resources'),
    (4, 'Marketing');       -- note: no employee will belong to this one yet

INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID) VALUES
    (101, 'Ali',    'Rezaei',   45000, 1),
    (102, 'Sara',   'Ahmadi',   62000, 2),
    (103, 'Reza',   'Karimi',   58000, 2),
    (104, 'Mina',   'Hosseini', 51000, 3),
    (105, 'Omid',   'Jafari',   47000, 1),
    (106, 'Leila',  'Moradi',   39000, NULL);  -- no department assigned yet
GO

-- ------------------------------------------------------------
-- Task A: list every department together with its employees.
-- Departments is the "right" table here, so every one of its
-- rows survives no matter what (Marketing included).
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentID,
    d.DepartmentName
FROM Employees AS e
RIGHT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentID, e.EmployeeID;

-- ------------------------------------------------------------
-- Task B: which departments currently have NO employees at all?
-- We check EmployeeID (the primary key of the unmatched side),
-- not DepartmentID, because a primary key can never legitimately
-- be NULL on a real row -- it is a safe and unambiguous signal
-- that "nothing matched" on the Employees side.
-- ------------------------------------------------------------
SELECT
    d.DepartmentID,
    d.DepartmentName
FROM Employees AS e
RIGHT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID IS NULL;

-- ------------------------------------------------------------
-- Task C: count how many employees each department has,
-- including departments with zero employees.
-- IMPORTANT: COUNT(*) would count the unmatched placeholder row
-- too, turning 0 into 1 for Marketing. COUNT(e.EmployeeID) skips
-- NULLs, so it correctly reports 0 for departments with nobody.
-- ------------------------------------------------------------
SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS CountEmployees
FROM Employees AS e
RIGHT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY d.DepartmentID;

-- ------------------------------------------------------------
-- Expected result A: 7 rows (6 employees + 1 placeholder row for
--   Marketing, whose employee columns are all NULL).
-- Expected result B: 1 row -> Marketing.
-- Expected result C: 4 rows -> Sales=2, Engineering=2,
--   Human Resources=1, Marketing=0.
-- ------------------------------------------------------------
