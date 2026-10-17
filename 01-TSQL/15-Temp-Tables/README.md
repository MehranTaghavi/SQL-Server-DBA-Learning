
# Temp Tables

A **temporary table** is a real table stored in the `tempdb` database
that SQL Server removes automatically when it is no longer needed.
It is the standard place to park an intermediate result while a
multi-step query, report or procedure does its work.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found. (Earlier chapters of this repo use `#temp` tables in passing,
for example in `06-Modify-Data`, but do not teach them.)

## Local, global and variables at a glance

|                          | `#name` (local)                       | `##name` (global)                  | `@name` (table variable) |
| ------------------------ | --------------------------------------- | ------------------------------------ | -------------------------- |
| Visible to               | the creating session (and code it runs) | every session                        | the current batch only     |
| Dropped when             | the session or procedure ends           | creator ends and nobody else uses it | the batch ends             |
| Affected by `ROLLBACK` | yes                                     | yes                                  | **no**               |
| Has statistics           | yes                                     | yes                                  | no                         |
| Can be indexed later     | yes                                     | yes                                  | only inline at declaration |

## Files — from simple to advanced

| Level        | File                                    | What it covers                                                                                                                                      |
| ------------ | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Setup        | `00-setup.sql`                        | Creates the permanent `Departments`, `Employees` and `Orders` tables the examples read from. Run this first.                                  |
| Beginner     | `01-create-local-temp-table.sql`      | `CREATE TABLE #name`, then `INSERT` / `UPDATE` / `DELETE` / `SELECT` like any table. Self-contained.                                      |
| Beginner     | `02-select-into-temp-table.sql`       | `SELECT ... INTO #name`, inherited data types, and the `WHERE 1 = 0` structure-only copy.                                                       |
| Beginner     | `03-scope-and-lifetime.sql`           | Who can see a temp table and when it disappears: dynamic SQL, a procedure's own temp table, and a procedure reading its caller's.                   |
| Beginner     | `04-global-temp-tables.sql`           | `##name` global temp tables and how to see one from a second session. Self-contained.                                                             |
| Intermediate | `05-constraints-and-indexes.sql`      | `PRIMARY KEY`, `DEFAULT`, `CHECK` and a nonclustered index on a temp table, and why not to name the constraints.                              |
| Intermediate | `06-temp-table-vs-table-variable.sql` | The `ROLLBACK` difference between a temp table and a table variable, shown directly. Self-contained.                                              |
| Intermediate | `07-staging-aggregation.sql`          | Compute department averages once into a temp table, then join back to find above-average earners.                                                   |
| Advanced     | `08-multi-step-report.sql`            | A three-step report built from two staging temp tables, including a `LEFT JOIN` for employees with no orders and an `ISNULL` truncation gotcha. |
| Advanced     | `09-update-with-output.sql`           | Staged bulk `UPDATE ... JOIN` with the `OUTPUT ... INTO` clause as an audit trail, inside a rolled-back transaction.                            |
| Advanced     | `10-cte-vs-temp-table.sql`            | The same question answered with a CTE referenced twice and with a temp table; compare the two execution plans.                                      |
| Advanced     | `11-top-n-per-group.sql`              | `ROW_NUMBER()` into a temp table, a clustered index on it, then top-2 earners per department.                                                     |
| Utility      | `12-cleanup-patterns.sql`             | `IF OBJECT_ID(...)` vs `DROP TABLE IF EXISTS`, and looking at temp tables in `tempdb.sys.tables`. Self-contained.                             |
| Utility      | `13-pitfalls.sql`                     | A temp table created inside `EXEC('...')` vanishes, and `SELECT ... INTO` copies the `IDENTITY` property. Self-contained.                     |

## Rules of thumb

- Use a `#temp` table when an intermediate result is large, is used
  more than once, or needs an index. Use a CTE when the logic is read
  once and a table variable only for small, simple row sets.
- Create the temp table **outside** transactions you intend to roll
  back, if you need the table itself to survive the rollback.
- Always `DROP TABLE IF EXISTS` (or the `IF OBJECT_ID` form) at the top
  of a script so it can be re-run in the same query window.

## How to run

Run `00-setup.sql` once, then any of `01`–`13` in any order. Files
marked "self-contained" do not even need `00`. File `10` is meant to be
observed rather than just run: press `Ctrl+M` in SSMS to include the
Actual Execution Plan before executing it.
