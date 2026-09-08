/* ============================================================
   CTE exercises - sample database setup
   Run this file once before running exercises 02 through 10.
   ============================================================ */

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

CREATE TABLE Departments
(
    DepartmentID   INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL
);

CREATE TABLE Employees
(
    EmployeeID   INT PRIMARY KEY IDENTITY(1,1),
    FirstName    NVARCHAR(50) NOT NULL,
    LastName     NVARCHAR(50) NOT NULL,
    ManagerID    INT NULL REFERENCES Employees(EmployeeID),
    DepartmentID INT NULL REFERENCES Departments(DepartmentID),
    Salary       DECIMAL(10,2) NOT NULL,
    HireDate     DATE NOT NULL
);

CREATE TABLE Orders
(
    OrderID     INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID  INT NOT NULL REFERENCES Employees(EmployeeID),
    OrderDate   DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL
);

INSERT INTO Departments (DepartmentName) VALUES
    ('IT'), ('Sales'), ('HR'), ('Finance');

INSERT INTO Employees (FirstName, LastName, ManagerID, DepartmentID, Salary, HireDate) VALUES
    ('Ali',     'Rezaei',   NULL, 1, 25000000, '2018-01-10'),
    ('Sara',    'Ahmadi',   1,    1, 18000000, '2019-03-15'),
    ('Reza',    'Karimi',   1,    2, 15000000, '2020-05-20'),
    ('Mina',    'Hosseini', 2,    1, 12000000, '2021-07-01'),
    ('Hossein', 'Ghasemi',  3,    2, 11000000, '2021-09-11'),
    ('Neda',    'Sadeghi',  3,    2, 14000000, '2022-02-18'),
    ('Amir',    'Moradi',   1,    3, 13000000, '2020-11-30'),
    ('Leila',   'Jafari',   7,    3,  9000000, '2022-06-05'),
    ('Kaveh',   'Norouzi',  1,    4, 16000000, '2019-08-22'),
    ('Parisa',  'Yousefi',  9,    4, 10000000, '2023-01-14');

INSERT INTO Orders (EmployeeID, OrderDate, TotalAmount) VALUES
    (3, '2023-01-05', 2500000),
    (3, '2023-02-11', 1800000),
    (5, '2023-01-20',  900000),
    (5, '2023-03-02', 1200000),
    (6, '2023-02-15', 3000000),
    (3, '2023-04-01',  750000);
GO
