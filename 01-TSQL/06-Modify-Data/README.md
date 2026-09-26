# 06 - Modify Data with T-SQL

This section follows the official [Modify data with T-SQL](https://learn.microsoft.com/en-us/training/modules/modify-data-with-transact-sql/) module.

- `INSERT VALUES` inserts specific rows; `INSERT SELECT` inserts the result of a query; `SELECT INTO` builds a new table from a query result.
- `IDENTITY` is a table-local auto-incrementing value, while `SEQUENCE` is an independent object that can be used across multiple tables.
- `UPDATE` changes data, and `UPDATE ... FROM` allows joining to another source while updating.
- `DELETE` removes rows; `TRUNCATE TABLE` removes all rows faster, with different logging behavior and restrictions.
- `MERGE` is used to synchronize inserts and updates between a source and a target; in sensitive systems, concurrency behavior and its restrictions need careful review.

All exercises use `#temp` tables or staging tables prefixed with `Modify`, and never touch the existing `dbo.Employees` table.
