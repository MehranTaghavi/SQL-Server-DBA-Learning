/* ============================================================
   00-setup.sql
   ============================================================
   Creates the two small tables used by every file in this
   folder: Departments and Employees. Run this once before any
   of the other scripts here.
   ============================================================ */

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
GO

CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
GO

CREATE TABLE Employees (
    EmployeeID   INT PRIMARY KEY,
    FirstName    VARCHAR(50),
    LastName     VARCHAR(50),
    DepartmentID INT,
    Salary       DECIMAL(10,2),
    HireDate     DATE
);
GO

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'HR');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate) VALUES
(1, 'Ali',  'Ahmadi', 1, 90000, '2018-03-01'),
(2, 'Sara', 'Nouri',  3, 75000, '2020-07-15'),
(3, 'Reza', 'Kamali', 2, 85000, '2016-11-20'),
(4, 'Mina', 'Jafari', 1, 95000, '2021-01-10'),
(5, 'Nima', 'Karimi', 2, 70000, '2019-05-05');
GO
