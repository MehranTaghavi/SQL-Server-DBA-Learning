/* ============================================================
   00-setup.sql
   ============================================================
   Creates the three PERMANENT tables that the temp-table
   examples in this folder read from: Departments, Employees and
   Orders. (Files 01, 04, 06 and 13 build everything they need
   themselves; all the others use these tables.)
   Run this once before the other scripts.
   ============================================================ */

DROP TABLE IF EXISTS Orders;
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

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    EmployeeID INT,
    OrderDate  DATE,
    Amount     DECIMAL(10,2)
);
GO

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'HR');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate) VALUES
(1, 'Ali',     'Ahmadi', 1, 90000, '2018-03-01'),
(2, 'Sara',    'Nouri',  3, 75000, '2020-07-15'),
(3, 'Reza',    'Kamali', 2, 85000, '2016-11-20'),
(4, 'Mina',    'Jafari', 1, 95000, '2021-01-10'),
(5, 'Nima',    'Karimi', 2, 70000, '2019-05-05'),
(6, 'Zahra',   'Alavi',  1, 88000, '2022-02-01'),
(7, 'Hossein', 'Razavi', 3, 72000, '2017-09-12'),
(8, 'Neda',    'Sadeghi', 2, 78000, '2023-04-18');

INSERT INTO Orders (OrderID, EmployeeID, OrderDate, Amount) VALUES
(101, 1, '2024-01-05', 1200),
(102, 1, '2024-02-10',  900),
(103, 3, '2024-01-20', 2500),
(104, 3, '2024-03-15', 1500),
(105, 4, '2024-02-25',  800),
(106, 5, '2024-04-02',  700),
(107, 1, '2024-04-18',  950),
(108, 8, '2024-05-05', 1300);
GO
