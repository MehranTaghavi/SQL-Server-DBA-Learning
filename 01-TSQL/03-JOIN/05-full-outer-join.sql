/* ============================================================
   Exercise 04.5 - FULL OUTER JOIN
   Topic   : Joins
   Goal    : Keep every row from BOTH tables, matched where
             possible. Unmatched columns on either side come
             back as NULL.
   ============================================================ */

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- ------------------------------------------------------------
-- Table setup: same base data as before, PLUS one extra
-- department and one extra employee that are both unmatched,
-- so a FULL OUTER JOIN has something interesting to show on
-- BOTH sides at once.
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
    (4, 'Marketing'),       -- unmatched: no employee points here
    (5, 'Finance');         -- unmatched: no employee points here

INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID) VALUES
    (101, 'Ali',    'Rezaei',   45000, 1),
    (102, 'Sara',   'Ahmadi',   62000, 2),
    (103, 'Reza',   'Karimi',   58000, 2),
    (104, 'Mina',   'Hosseini', 51000, 3),
    (105, 'Omid',   'Jafari',   47000, 1),
    (106, 'Leila',  'Moradi',   39000, NULL),  -- unmatched: no department
    (107, 'Kaveh',  'Nouri',    43000, NULL);  -- unmatched: no department
GO

-- ------------------------------------------------------------
-- Task A: list every employee and every department side by
-- side, matched where possible. Nothing from either table is
-- dropped.
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentID,
    d.DepartmentName
FROM Employees AS e
FULL OUTER JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentID, e.EmployeeID;

-- ------------------------------------------------------------
-- Task B: show only the rows that did NOT find a match on
-- either side -- i.e. employees with no department, and
-- departments with no employees.
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentID,
    d.DepartmentName
FROM Employees AS e
FULL OUTER JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID IS NULL
   OR d.DepartmentID IS NULL;

-- ------------------------------------------------------------
-- Task C: compare the row count of FULL OUTER JOIN against
-- INNER JOIN, to see exactly how many "orphan" rows FULL OUTER
-- JOIN adds back in.
-- ------------------------------------------------------------
SELECT
    (SELECT COUNT(*)
     FROM Employees AS e
     INNER JOIN Departments AS d
         ON e.DepartmentID = d.DepartmentID)      AS InnerJoinRowCount,
    (SELECT COUNT(*)
     FROM Employees AS e
     FULL OUTER JOIN Departments AS d
         ON e.DepartmentID = d.DepartmentID)      AS FullOuterJoinRowCount;

-- ------------------------------------------------------------
-- Expected result A: 9 rows total (5 matched + 2 unmatched
--   employees [Leila, Kaveh] + 2 unmatched departments
--   [Marketing, Finance]).
-- Expected result B: 4 rows (Leila, Kaveh, Marketing, Finance).
-- Expected result C: InnerJoinRowCount = 5,
--   FullOuterJoinRowCount = 9. The difference (4) is exactly
--   the 4 unmatched rows found in Task B.
-- ------------------------------------------------------------
