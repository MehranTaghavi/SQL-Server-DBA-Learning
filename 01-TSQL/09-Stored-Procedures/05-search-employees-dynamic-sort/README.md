# Exercise 05 - Dynamic SQL with sp_executesql

A search procedure with optional filters and a user-selectable sort
column, built safely with `sp_executesql`: filter values are passed
as real parameters (never string-concatenated), and the sort column —
an identifier, which can't be parameterized the same way — is
validated against a whitelist and wrapped in `QUOTENAME()`.

Uses the sample tables created by `00-setup.sql` (from the `07-CTE`
folder).

## Files

| File                                | What it does                                                                                                          |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `01-procedure.sql`                | Creates`dbo.SearchEmployeesDynamicSort`. Run this first.                                                            |
| `02-test-filtered-search.sql`     | Combined`DepartmentID` + `MinSalary` filters, with a non-default, whitelisted sort column.                        |
| `03-test-default-search.sql`      | No filters supplied: confirms all employees return, sorted by the default column.                                     |
| `04-test-invalid-sort-column.sql` | A real column name that is NOT on the whitelist: confirms it is rejected via`THROW` before the SQL string is built. |

## Run order

1. Run `00-setup.sql` (from `07-CTE`) if the sample tables don't exist yet.
2. Run `01-procedure.sql`.
3. Run `02`, `03`, and `04` in any order — each is self-contained.
