/* ============================================================
   Exercise 04.3 - SELF JOIN
   Topic   : Joins
   Goal    : Join a table to itself, useful when rows in the
             same table reference other rows in that table
             (here: an employee's manager is also an employee).
   ============================================================ */

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
GO

-- ------------------------------------------------------------
-- Table setup
-- Note the extra ManagerID column: it stores the EmployeeID
-- of that person's manager, pointing back into the SAME table.
-- ------------------------------------------------------------
CREATE TABLE Employees (
    EmployeeID   INT PRIMARY KEY,
    FirstName    VARCHAR(50) NOT NULL,
    LastName     VARCHAR(50) NOT NULL,
    ManagerID    INT NULL,      -- NULL means "has no manager" (e.g. the CEO)
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
GO

-- Sample data: a small org chart
-- Sara (102) is the top of the chain -> ManagerID NULL
-- Reza (103) and Mina (104) report to Sara
-- Ali (101) and Omid (105) report to Reza
INSERT INTO Employees (EmployeeID, FirstName, LastName, ManagerID) VALUES
    (102, 'Sara',  'Ahmadi',   NULL),
    (103, 'Reza',  'Karimi',   102),
    (104, 'Mina',  'Hosseini', 102),
    (101, 'Ali',   'Rezaei',   103),
    (105, 'Omid',  'Jafari',   103);
GO

-- ------------------------------------------------------------
-- Task: list every employee next to the name of their manager.
-- We join the table to a second "copy" of itself (aliased mgr),
-- matching each employee's ManagerID to the manager's EmployeeID.
-- LEFT JOIN is used so Sara (who has no manager) still shows up,
-- just with a NULL manager name instead of being dropped.
-- ------------------------------------------------------------
SELECT
    emp.EmployeeID,
    emp.FirstName + ' ' + emp.LastName  AS EmployeeName,
    mgr.FirstName + ' ' + mgr.LastName  AS ManagerName
FROM Employees AS emp
LEFT JOIN Employees AS mgr
    ON emp.ManagerID = mgr.EmployeeID
ORDER BY emp.EmployeeID;

-- ------------------------------------------------------------
-- Expected result: 5 rows. Sara's ManagerName is NULL because
-- she is the top of the chain. Everyone else shows their direct
-- manager's full name.
-- ------------------------------------------------------------
