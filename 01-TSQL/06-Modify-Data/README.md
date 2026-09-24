# 06 - Modify Data with T-SQL

This section follows the official [Modify data with T-SQL](https://learn.microsoft.com/en-us/training/modules/modify-data-with-transact-sql/) module.

- `INSERT VALUES` inserts specific rows; `INSERT SELECT` inserts the result of a query, and `SELECT INTO` creates a new table from the query result.
- `IDENTITY` is a table-specific auto-incrementing value, whereas `SEQUENCE` is an independent object that can be shared across multiple tables.
- `UPDATE` modifies data, and `UPDATE ... FROM` allows updating based on a join to another source.
- `DELETE` removes rows; `TRUNCATE TABLE` deletes all rows much faster with different logging and constraint implications.
- `MERGE` is used to synchronize inserts and updates between a source and a target; in critical systems, careful consideration of concurrency and constraints is necessary.

All exercises use `#temp` tables or staging tables with a `Modify` prefix and do not alter the existing `dbo.Employees` table.
