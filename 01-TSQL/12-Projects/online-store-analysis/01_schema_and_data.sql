/*=============================================================================
  Project: Online Store Sales Analysis (T-SQL Portfolio Project)
  File:    01_schema_and_data.sql
  Author:  Mehran Taghavi Afkham
  Purpose: Creates a small, self-contained "online store" database with
           Customers, Products, Orders, and OrderItems tables, then loads
           sample data. This is the schema/data foundation used by the
           analysis queries in 02_analysis_queries.sql.

  How to run:
    1. Open in SSMS or Azure Data Studio, connected to any disposable
       SQL Server instance/database.
    2. Run this entire file once to create the database, tables, and data.
    3. Then run 02_analysis_queries.sql against the same database.
=============================================================================*/

-- Create a dedicated database so this project never touches other data
IF DB_ID('OnlineStoreSample') IS NULL
BEGIN
    CREATE DATABASE OnlineStoreSample;
END
GO

USE OnlineStoreSample;
GO

-- Drop tables if they already exist, so this script is safely re-runnable
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders', 'U')     IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U')   IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U')  IS NOT NULL DROP TABLE dbo.Customers;
GO

/*-----------------------------------------------------------------------------
  Table: Customers
  One row per customer.
-----------------------------------------------------------------------------*/
CREATE TABLE dbo.Customers (
    CustomerID   INT IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(100)  NOT NULL,
    City         NVARCHAR(50)   NOT NULL,
    JoinDate     DATE           NOT NULL
);
GO

/*-----------------------------------------------------------------------------
  Table: Products
  One row per product available in the store.
-----------------------------------------------------------------------------*/
CREATE TABLE dbo.Products (
    ProductID    INT IDENTITY(1,1) PRIMARY KEY,
    ProductName  NVARCHAR(100)  NOT NULL,
    Category     NVARCHAR(50)   NOT NULL,
    UnitPrice    DECIMAL(10,2)  NOT NULL
);
GO

/*-----------------------------------------------------------------------------
  Table: Orders
  One row per order placed by a customer.
-----------------------------------------------------------------------------*/
CREATE TABLE dbo.Orders (
    OrderID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID   INT            NOT NULL REFERENCES dbo.Customers(CustomerID),
    OrderDate    DATE           NOT NULL
);
GO

/*-----------------------------------------------------------------------------
  Table: OrderItems
  One row per product line within an order (an order can have many items).
-----------------------------------------------------------------------------*/
CREATE TABLE dbo.OrderItems (
    OrderItemID  INT IDENTITY(1,1) PRIMARY KEY,
    OrderID      INT            NOT NULL REFERENCES dbo.Orders(OrderID),
    ProductID    INT            NOT NULL REFERENCES dbo.Products(ProductID),
    Quantity     INT            NOT NULL,
    UnitPrice    DECIMAL(10,2)  NOT NULL   -- price at time of order
);
GO

/*=============================================================================
  Sample data
=============================================================================*/

INSERT INTO dbo.Customers (FullName, City, JoinDate) VALUES
('Sara Ahmadi',    'Tehran',  '2024-01-15'),
('Reza Karimi',    'Mashhad', '2024-02-20'),
('Niloofar Rezaei', 'Isfahan', '2024-03-05'),
('Amir Hosseini',  'Tehran',  '2024-03-18'),
('Mina Jafari',    'Shiraz',  '2024-04-02'),
('Farhad Moradi',  'Tabriz',  '2024-04-25'),
('Elham Sadeghi',  'Tehran',  '2024-05-10');
GO

INSERT INTO dbo.Products (ProductName, Category, UnitPrice) VALUES
('Wireless Mouse',      'Electronics', 12.50),
('Mechanical Keyboard', 'Electronics', 45.00),
('USB-C Hub',           'Electronics', 22.00),
('Notebook',             'Stationery',  3.50),
('Desk Lamp',            'Home',       18.00),
('Water Bottle',         'Home',        9.00);
GO

-- Orders spread across several months so monthly analysis is meaningful
INSERT INTO dbo.Orders (CustomerID, OrderDate) VALUES
(1, '2025-01-05'),
(2, '2025-01-12'),
(1, '2025-02-03'),
(3, '2025-02-10'),
(4, '2025-02-20'),
(2, '2025-03-01'),
(5, '2025-03-08'),
(1, '2025-03-15'),
(6, '2025-03-22'),
(3, '2025-04-02'),
(4, '2025-04-11'),
(7, '2025-04-18'),
(1, '2025-04-25');
GO

INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 2, 12.50),
(1, 4, 3, 3.50),
(2, 2, 1, 45.00),
(3, 3, 1, 22.00),
(3, 5, 1, 18.00),
(4, 1, 1, 12.50),
(5, 2, 2, 45.00),
(6, 6, 4, 9.00),
(7, 4, 5, 3.50),
(8, 2, 1, 45.00),
(8, 3, 1, 22.00),
(9, 5, 2, 18.00),
(10, 1, 3, 12.50),
(11, 6, 1, 9.00),
(12, 2, 1, 45.00),
(12, 1, 1, 12.50),
(13, 4, 2, 3.50),
(13, 3, 1, 22.00);
GO