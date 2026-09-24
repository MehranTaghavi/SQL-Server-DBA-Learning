# 01 - Introduction to Transact-SQL

This section aligns with the official [Introduction to Transact-SQL](https://learn.microsoft.com/en-us/training/modules/introduction-to-transact-sql/) module.

## Core Concepts

- **SQL vs. T-SQL:** SQL is the standard querying language; T-SQL is SQL Server's extension that provides control-of-flow language, variables, error handling, and stored procedures.
- **Declarative Nature:** In SQL, you describe the desired result, not the step-by-step algorithm to achieve it.
- **Relational Data:** Data is stored in tables and relationships. A `PRIMARY KEY` uniquely identifies each row, and a `FOREIGN KEY` maintains referential integrity between tables.
- **Set-Based Processing:** Operations are performed on a set of rows rather than looping through each row individually; this approach is usually more readable and faster.
- **Schema and Fully Qualified Names:** Using two-part names like `dbo.Employees` reduces ambiguity and helps SQL Server resolve objects efficiently.
- **Statement Categories:** DML for data manipulation (`SELECT`, `INSERT`, `UPDATE`, `DELETE`), DDL for data definition (`CREATE`, `ALTER`, `DROP`), and DCL for data control/permissions (`GRANT`, `DENY`, `REVOKE`).
- **Logical Order of Operations in SELECT:** `FROM ← WHERE ← GROUP BY ← HAVING ← SELECT ← ORDER BY`; this logical processing order differs from the syntax order.
- **Data Types and Conversions:** `CAST`/`TRY_CAST` and `CONVERT`/`TRY_CONVERT` are used for explicit conversions; `PARSE`/`TRY_PARSE` is suitable for culture-specific conversions.
- **NULL Handling:** Use `IS NULL` and `IS NOT NULL` for checking, `ISNULL` or `COALESCE` for replacement, and `NULLIF` to return `NULL` if two expressions are equal.

The scripts use a sample `Employees` table and will create it within the same script if it does not already exist.
