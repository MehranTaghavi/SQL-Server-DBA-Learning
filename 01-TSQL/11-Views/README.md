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

## Updatable views: the short version

A view is updatable only under narrow conditions: no aggregate
functions, no `GROUP BY`/`DISTINCT`/`UNION`, no computed columns —
and if it joins multiple tables, a single `INSERT`/`UPDATE` statement
through it can only touch columns from **one** of those tables at a
time. `WITH CHECK OPTION` is a closely related safeguard for filtered
views: without it, a write can silently push a row outside the view's
own `WHERE` clause; with it, that same write is rejected instead.

This module is intentionally scoped to updatable views and `WITH
CHECK OPTION`. Other advanced topics (`WITH SCHEMABINDING`, indexed
views) are not covered here.

## How to run

Run `00-setup.sql` once, then the rest in order (`01` through `05`) —
`03` and `04` modify data that later files assume is in a particular
state.