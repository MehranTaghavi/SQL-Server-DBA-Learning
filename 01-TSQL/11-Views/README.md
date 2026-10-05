# Views

A **view** is a saved `SELECT` query stored in the database under its
own name. Once created, you query it exactly like a table — but it
doesn't hold its own copy of the data; every time it's queried, SQL
Server runs the underlying query against the real, live tables.

## Why use a view?

- **Simplify repeated queries.** If several people (or several
  reports) need the same JOIN over and over, a view lets them write
  `SELECT * FROM vw_Something` instead of repeating the JOIN every
  time.
- **Hide complexity.** Whoever queries the view doesn't need to know
  how many tables it joins, or what filter it applies — they just see
  the result shape.
- **A stable, simple interface.** If the underlying tables' structure
  changes later, the view can often be updated once, in one place,
  without every query that uses it needing to change too.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found.

## Files

| File | What it covers |
|---|---|
| `00-setup.sql` | Creates the `Departments` and `Employees` tables used by every file here. Run this first. |
| `01-create-basic-view.sql` | A view joining `Employees` and `Departments`, then querying it with `WHERE` and `ORDER BY` like an ordinary table. |
| `02-view-with-filter.sql` | A view whose own query already has a `WHERE` clause built in, so every caller automatically only sees rows that satisfy it. |
| `03-updatable-view-basic.sql` | `UPDATE` and `INSERT` through a single-table view, showing SQL Server translates the write straight through to the real table. |
| `04-check-option.sql` | `WITH CHECK OPTION`: by default a row can be updated through a filtered view so it no longer matches the view's own `WHERE` clause (it just disappears from the view); `WITH CHECK OPTION` rejects that write outright instead. |
| `05-non-updatable-view.sql` | A multi-table (JOIN) view where a single `UPDATE` touches columns from two different base tables at once — deliberately triggers the "not updatable" error, for contrast with `03`. |
| `06-schemabinding-basic.sql` | `WITH SCHEMABINDING`: the two syntax requirements it imposes (two-part table names, explicit column list), and that a schemabound view still queries exactly like any other view. |
| `07-schemabinding-protection.sql` | Proves the protection is real and column-level: dropping a column the view references is rejected outright; dropping an unrelated column on the same table still works fine. |
| `08-non-schemabound-comparison.sql` | The contrast case, in a fully self-contained throwaway table: without `SCHEMABINDING`, dropping a column the view depends on succeeds immediately, and the view only breaks later, the next time it's queried. |
| `09-indexed-view-foundation.sql` | Starts indexed views: builds a schemabound aggregate view with the required `SET` options and `COUNT_BIG(*)`, ready to be indexed. |
| `10-create-indexed-view.sql` | Creates the required first index (`UNIQUE CLUSTERED`) on the view and verifies it from `sys.indexes`. |
| `11-indexed-view-maintenance.sql` | Demonstrates automatic indexed-view maintenance on base-table `INSERT`/`UPDATE`, then uses `ROLLBACK` to keep the dataset unchanged. |
| `12-indexed-view-count-big-rule.sql` | Intentionally violates the aggregate rule (missing `COUNT_BIG`) to show the expected indexed-view creation error. |

## Updatable views: the short version

A view is updatable only under narrow conditions: no aggregate
functions, no `GROUP BY`/`DISTINCT`/`UNION`, no computed columns —
and if it joins multiple tables, a single `INSERT`/`UPDATE` statement
through it can only touch columns from **one** of those tables at a
time. `WITH CHECK OPTION` is a closely related safeguard for filtered
views: without it, a write can silently push a row outside the view's
own `WHERE` clause; with it, that same write is rejected instead.

## WITH SCHEMABINDING: the short version

A plain view has no protection: if someone drops or changes a column
it depends on, the view just silently breaks, and nobody finds out
until the next time it's queried. `WITH SCHEMABINDING` locks the view
to the exact columns it references — any `ALTER`/`DROP` that would
break it is rejected immediately, at the moment it's attempted, not
discovered later. It requires two-part table names (`dbo.Employees`,
not `Employees`) and an explicit column list (no `SELECT *`).
`SCHEMABINDING` is also a prerequisite for creating an index on a
view (an "indexed view"), covered in files `09` through `12`.

## Indexed views: the short version

An indexed view is a view with a **unique clustered index** on it.
That index materializes the view's result physically, which can help
for repeated expensive aggregations. But it has strict rules:
`SCHEMABINDING` is mandatory, required `SET` options must be enabled,
and grouped aggregate views must include `COUNT_BIG(*)`.

## How to run

Run `00-setup.sql` once, then the rest in order (`01` through `12`) —
`03` and `04` modify data that later files assume is in a particular
state. `08` is fully self-contained and doesn't depend on the others.
For indexed views, run `09` before `10`, then `11` and `12`; `11` uses
a transaction with `ROLLBACK`, so it leaves no permanent data change.