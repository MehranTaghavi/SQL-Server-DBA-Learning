/* ============================================================
   Setup: Create tables and insert sample data for Set Operators
   ============================================================ */

CREATE TABLE Employees_HQ (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE Employees_Branch (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Insert Data into HQ
INSERT INTO Employees_HQ (EmployeeID, FirstName, LastName, Department, Salary) VALUES 
(1, 'Ali', 'Ahmadi', 'IT', 90000),
(2, 'Sara', 'Nouri', 'HR', 75000),
(3, 'Reza', 'Kamali', 'Sales', 85000),  -- Overlaps with Branch
(4, 'Mina', 'Jafari', 'IT', 95000);    -- Overlaps with Branch

-- Insert Data into Branch
INSERT INTO Employees_Branch (EmployeeID, FirstName, LastName, Department, Salary) VALUES 
(3, 'Reza', 'Kamali', 'Sales', 85000),  -- Overlaps with HQ
(4, 'Mina', 'Jafari', 'IT', 95000),    -- Overlaps with HQ
(5, 'Nima', 'Karimi', 'Marketing', 70000),
(6, 'Zahra', 'Mousavi', 'IT', 88000);
