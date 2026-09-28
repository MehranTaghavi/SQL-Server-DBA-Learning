# Views (Introductory)

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

This module is intentionally introductory — it covers only `CREATE
VIEW` and querying a view. More advanced topics (updatable views,
`WITH SCHEMABINDING`, indexed views, view permissions for security)
are not covered here.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found.

## Files

| File | What it covers |
|---|---|
| `00-setup.sql` | Creates the `Departments` and `Employees` tables used by every file here. Run this first. |
| `01-create-basic-view.sql` | A view joining `Employees` and `Departments`, then querying it with `WHERE` and `ORDER BY` like an ordinary table. |
| `02-view-with-filter.sql` | A view whose own query already has a `WHERE` clause built in, so every caller automatically only sees rows that satisfy it. |

## How to run

Run `00-setup.sql` once, then `01` and `02` in any order — each creates
its own view and queries it immediately.