/* ============================================================
   Exercise 04.1 - INNER JOIN
   Topic   : Joins
   Goal    : Combine rows from two related tables, keeping only
             the rows that have a match in BOTH tables.
   ============================================================ */

-- Clean slate: drop tables if they already exist from a previous run
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- ------------------------------------------------------------
-- Table setup
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
    DepartmentID   INT NULL,              -- can be NULL: not every employee is assigned yet
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

-- Sample data
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
    (106, 'Leila',  'Moradi',   39000, NULL);  -- note: no department assigned yet
GO

-- ------------------------------------------------------------
-- Task: list every employee together with the name of the
-- department they belong to. Employees with no department
-- (like Leila) should NOT appear, because INNER JOIN only
-- keeps rows that match on both sides.
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees AS e
INNER JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID   -- the join condition: match on DepartmentID
ORDER BY e.EmployeeID;

-- ------------------------------------------------------------
-- Expected result: 5 rows (Leila is excluded because her
-- DepartmentID is NULL, so it can't match anything).
-- Marketing (DepartmentID 4) also disappears from the result,
-- because no employee has DepartmentID = 4.
-- ------------------------------------------------------------
