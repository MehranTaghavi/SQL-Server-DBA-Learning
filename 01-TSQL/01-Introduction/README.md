# 01 - Introduction to Transact-SQL

This section follows the official [Introduction to Transact-SQL](https://learn.microsoft.com/en-us/training/modules/introduction-to-transact-sql/) module.

## Core concepts

- **SQL vs. T-SQL:** SQL is the standard query language; T-SQL is SQL Server's extended dialect, adding flow control, variables, error handling, and stored procedures.
- **Declarative:** In SQL you describe the result you want, not the step-by-step algorithm to produce it.
- **Relational data:** Data is stored in tables and relationships. `PRIMARY KEY` makes each row unique, and `FOREIGN KEY` preserves referential integrity between tables.
- **Set-based processing:** Operations act on a whole set of rows at once, not via a per-row loop — this is generally more readable and faster.
- **Schema and fully-qualified names:** Using names like `dbo.Employees` reduces ambiguity and helps SQL Server resolve the object.
- **Statement categories:** DML for working with data (`SELECT`, `INSERT`, `UPDATE`, `DELETE`), DDL for defining structure (`CREATE`, `ALTER`, `DROP`), and DCL for permissions (`GRANT`, `DENY`, `REVOKE`).
- **Logical order of SELECT:** `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY` — this is not the same as the order the clauses are written in.
- **Data type conversion:** `CAST`/`TRY_CAST` and `CONVERT`/`TRY_CONVERT` perform explicit conversion; `PARSE`/`TRY_PARSE` is suited to culture-aware conversion.
- **NULL:** Use `IS NULL`/`IS NOT NULL` to test for it, `ISNULL` or `COALESCE` to substitute a value, and `NULLIF` to convert a value to `NULL` when two expressions are equal.

The scripts are written against a sample `Employees` table and create it themselves if it doesn't already exist.
