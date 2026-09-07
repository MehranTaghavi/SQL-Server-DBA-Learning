# SELECT and filtering

Start here to learn how SQL Server turns a table into a precise result set. The `01-basics` scripts cover SELECT, WHERE, LIKE, BETWEEN, IN, ORDER BY, TOP, and NULL predicates. The [Subqueries](./Subqueries) folder then applies those skills to scalar, correlated, EXISTS, and CASE-based analysis.

Run each script from top to bottom in SSMS. The sample table definition is documented below.

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(30),
    Position NVARCHAR(30),
    Salary INT,
    HireDate DATE
);
