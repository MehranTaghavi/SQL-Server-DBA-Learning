/* ============================================================
   Exercise 04.2 - LEFT JOIN
   Topic   : Joins
   Goal    : Keep ALL rows from the left table, even when there
             is no matching row on the right. Unmatched columns
             come back as NULL.
   ============================================================ */

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- ------------------------------------------------------------
-- Table setup (same shape as exercise 01, same sample data,
-- so this script can be run completely on its own)
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
    (4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID) VALUES
    (101, 'Ali',    'Rezaei',   45000, 1),
    (102, 'Sara',   'Ahmadi',   62000, 2),
    (103, 'Reza',   'Karimi',   58000, 2),
    (104, 'Mina',   'Hosseini', 51000, 3),
    (105, 'Omid',   'Jafari',   47000, 1),
    (106, 'Leila',  'Moradi',   39000, NULL);
GO

-- ------------------------------------------------------------
-- Task A: list EVERY employee, with their department name
-- when they have one, and NULL when they don't.
-- Employees is the "left" table here, so every one of its
-- rows survives no matter what.
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName        -- will show NULL for Leila
FROM Employees AS e
LEFT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;

-- ------------------------------------------------------------
-- Task B: the reverse question — which departments currently
-- have NO employees at all? We flip the LEFT JOIN so
-- Departments is on the left, then filter for the rows where
-- nothing matched on the Employees side.
-- ------------------------------------------------------------
SELECT
    d.DepartmentID,
    d.DepartmentName
FROM Departments AS d
LEFT JOIN Employees AS e
    ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID IS NULL;   -- true only when nothing matched, i.e. the department is empty

-- ------------------------------------------------------------
-- Expected result A: 6 rows total, Leila's DepartmentName is NULL.
-- Expected result B: 1 row -> Marketing (no employee points to it).
-- ------------------------------------------------------------
