/* ============================================================
   00-setup.sql
   ============================================================
   Creates the tables used by files 01, 02 and 05 in this folder:
     - Employees       : the table the triggers are attached to
     - SalaryAudit     : receives one row per salary change
     - EmployeeArchive : receives one row per deleted employee
   Files 03 and 04 are fully self-contained and create their own
   throwaway tables. Run this file once before the others.
   ============================================================ */

DROP TABLE IF EXISTS SalaryAudit;
DROP TABLE IF EXISTS EmployeeArchive;
DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Salary     DECIMAL(10,2)
);
GO

CREATE TABLE SalaryAudit (
    AuditID    INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary  DECIMAL(10,2),
    NewSalary  DECIMAL(10,2),
    ChangedAt  DATETIME2 DEFAULT SYSDATETIME(),
    ChangedBy  SYSNAME   DEFAULT SUSER_SNAME()
);
GO

CREATE TABLE EmployeeArchive (
    EmployeeID INT,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DeletedAt  DATETIME2 DEFAULT SYSDATETIME()
);
GO

INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary) VALUES
(1, 'Ali',  'Ahmadi', 90000),
(2, 'Sara', 'Nouri',  75000),
(3, 'Reza', 'Kamali', 85000);
GO
