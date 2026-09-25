# Dynamic SQL and sp_executesql in T-SQL

## Abstract

This document explains Dynamic SQL in Microsoft SQL Server: what
problem it solves, the mechanics and security properties of
`sp_executesql` compared to the simpler `EXEC()` form, the specific
constraint that identifiers (table and column names) cannot be
parameterized the same way values can, and the performance
implications of each approach. This topic is not covered by the
primary T-SQL reference document (`T_SQL_1.pdf`) used elsewhere in
this learning project; it was searched for specifically and found
absent. The present document is compiled independently from general
SQL Server documentation and practice.

## 1. Introduction

Ordinary T-SQL is static: the shape of a query — which tables,
which columns, which conditions — is fixed at the time the code is
written. Some scenarios require a query whose shape is not known
until runtime: an optional set of search filters where any
combination might be supplied, a caller-selected sort column, or a
table/schema name that varies by tenant. Dynamic SQL is the
construction of a T-SQL statement as a string at runtime, followed by
its execution.

## 2. Two Ways to Execute Dynamic SQL

### 2.1 EXEC() with String Concatenation

```sql
DECLARE @sql NVARCHAR(MAX);
SET @sql = 'SELECT * FROM Employees WHERE LastName = ''' + @LastName + '''';
EXEC(@sql);
```

Here, the value of `@LastName` is spliced directly into the SQL text
before it is executed. If `@LastName` contains characters that are
themselves valid T-SQL syntax — for example
`'; DROP TABLE Employees; --` — that text becomes part of the
statement SQL Server executes. This is the SQL Injection
vulnerability class, and it exists specifically because a value has
been treated as executable text rather than as data.

### 2.2 sp_executesql with Parameterization

```sql
DECLARE @sql    NVARCHAR(MAX) = N'SELECT * FROM Employees WHERE LastName = @LastName';
DECLARE @params NVARCHAR(MAX) = N'@LastName NVARCHAR(100)';

EXEC sp_executesql @sql, @params, @LastName = @LastName;
```

`sp_executesql` accepts the SQL text, a string describing the
parameter signature (in the same syntax used to declare a stored
procedure's parameters), and the corresponding parameter values.
Critically, `@LastName`'s value is never concatenated into the SQL
string — it is passed the same way a parameter is passed to an
ordinary stored procedure. This makes SQL Injection through this
value impossible, because the value can never be interpreted as part
of the statement's syntax.

## 3. The Identifier Problem

Parameterization, as shown above, works for *values* — things that
appear on the right-hand side of a comparison, or as data to insert.
It does not work for *identifiers* — table names, column names,
schema names. There is no way to write
`sp_executesql N'SELECT * FROM @TableName', N'@TableName ...'`; a
table name cannot be supplied as a bound parameter, because
`sp_executesql`'s parameters are values substituted into an
already-parsed execution plan, and identifiers must be resolved at
parse time.

When an identifier genuinely needs to vary at runtime (a
caller-selected sort column, for instance), the safe pattern is:

1. Validate the identifier against a fixed whitelist of allowed
   values, rejecting anything not on the list.
2. Wrap the validated identifier in `QUOTENAME()`, which brackets it
   (`[ColumnName]`) so that it is always treated as a single
   identifier token, never as executable text, even if it happens to
   contain characters that would otherwise be problematic.

```sql
IF @SortColumn NOT IN ('EmployeeID', 'LastName', 'Salary', 'HireDate')
BEGIN
    THROW 51020, 'Invalid sort column.', 1;
END

SET @sql += N' ORDER BY ' + QUOTENAME(@SortColumn);
```

Concatenating an unvalidated identifier directly into dynamic SQL —
even without any apparent "value" being injected — reopens the same
class of vulnerability as Section 2.1, because the string being
concatenated is still attacker-influenced text placed directly into
executable SQL.

## 4. A Worked Pattern: Optional Search Filters

A common legitimate use of dynamic SQL is a search procedure with
several optional filter parameters, where any subset might be
supplied by the caller:

```sql
CREATE OR ALTER PROCEDURE dbo.SearchEmployees
    @DepartmentID INT = NULL,
    @MinSalary    DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql    NVARCHAR(MAX) = N'SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary FROM Employees WHERE 1 = 1';
    DECLARE @params NVARCHAR(MAX) = N'@DepartmentID INT, @MinSalary DECIMAL(10,2)';

    IF @DepartmentID IS NOT NULL
        SET @sql += N' AND DepartmentID = @DepartmentID';

    IF @MinSalary IS NOT NULL
        SET @sql += N' AND Salary >= @MinSalary';

    EXEC sp_executesql @sql, @params, @DepartmentID = @DepartmentID, @MinSalary = @MinSalary;
END;
```

Each optional condition is appended to the SQL text only when its
corresponding parameter is supplied, but the parameter's *value* is
still passed through `sp_executesql`'s parameter mechanism rather
than being concatenated — the string being built varies in
structure, not in the raw values it contains.

## 5. Performance Characteristics

`sp_executesql`, used with proper parameterization, allows SQL
Server to cache and reuse the resulting execution plan in the plan
cache, in the same way a stored procedure's plan is cached — because
the SQL text itself remains identical across calls with different
parameter values, only the bound values change. `EXEC()` with values
concatenated directly into the string produces a distinct string
(and therefore, typically, a distinct, non-reusable plan) for every
distinct value, which leads to plan cache bloat and repeated
compilation overhead under load.

## 6. Common Implementation Pitfalls

1. Using `EXEC()` with concatenated values instead of
   `sp_executesql` with parameters.
2. Concatenating a caller-supplied identifier (table or column name)
   into the SQL string without validating it against a whitelist.
3. Forgetting `QUOTENAME()` when an identifier, even a validated
   one, is inserted into the string.
4. Declaring a parameter's type in `@paramDefinition` inconsistently
   with the actual column's type, causing implicit conversion and
   potential performance degradation or unexpected comparison
   behavior.

## 7. Review Questions

1. Why does `sp_executesql` prevent SQL Injection for parameter
   values, while `EXEC()` with concatenation does not?
2. Why can't a table or column name be passed as an
   `sp_executesql` parameter the same way a value can?
3. What two steps make a caller-selected sort column safe to use in
   dynamic SQL?
4. Why does parameterized dynamic SQL generally perform better under
   load than dynamic SQL built entirely through string concatenation?

## References

- T_SQL_1.pdf (personal reference document) — searched specifically
  for Dynamic SQL / `sp_executesql` content; not present.
- Microsoft Learn — *sp_executesql (Transact-SQL)*
- Microsoft Learn — *QUOTENAME (Transact-SQL)*
- Microsoft Learn — *SQL Injection*