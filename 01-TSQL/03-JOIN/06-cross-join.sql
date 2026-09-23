/* ============================================================
   Exercise 04.6 - CROSS JOIN
   Topic   : Joins
   Goal    : Produce every possible combination of rows from two
             tables -- the Cartesian product -- with no ON
             condition at all.
   ============================================================ */

IF OBJECT_ID('dbo.Employees', 'U')   IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
IF OBJECT_ID('dbo.BonusTypes', 'U')  IS NOT NULL DROP TABLE dbo.BonusTypes;
GO

-- ------------------------------------------------------------
-- Table setup (same base data as exercises 01/02, plus one new
-- small lookup table used only in Task B)
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

CREATE TABLE BonusTypes (
    BonusType VARCHAR(30) NOT NULL
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

INSERT INTO BonusTypes (BonusType) VALUES
    ('Performance'),
    ('Loyalty'),
    ('Referral');
GO

-- ------------------------------------------------------------
-- Task A: every possible (employee, department) pairing, with
-- no matching condition. This is the raw Cartesian product.
-- ------------------------------------------------------------
SELECT
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName
FROM Employees AS e
CROSS JOIN Departments AS d
ORDER BY EmployeeName, d.DepartmentName;

-- ------------------------------------------------------------
-- Task B: a report matrix -- every department combined with
-- every possible bonus type, ready to be filled in later.
-- ------------------------------------------------------------
SELECT
    d.DepartmentName,
    b.BonusType
FROM Departments AS d
CROSS JOIN BonusTypes AS b
ORDER BY d.DepartmentName, b.BonusType;

-- ------------------------------------------------------------
-- Task C: a self CROSS JOIN -- every department paired with
-- every department, including itself.
-- ------------------------------------------------------------
SELECT
    d1.DepartmentName AS DepartmentA,
    d2.DepartmentName AS DepartmentB
FROM Departments AS d1
CROSS JOIN Departments AS d2
ORDER BY d1.DepartmentName, d2.DepartmentName;

-- ------------------------------------------------------------
-- Expected result A: 24 rows (6 employees x 4 departments).
-- Expected result B: 12 rows (4 departments x 3 bonus types).
-- Expected result C: 16 rows (4 departments x 4 departments,
--   including each department paired with itself).
-- ------------------------------------------------------------
