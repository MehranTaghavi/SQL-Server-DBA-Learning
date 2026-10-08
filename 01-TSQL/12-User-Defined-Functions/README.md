# User-Defined Functions (UDF)

A **user-defined function** is reusable logic you create yourself,
which returns either a single value (**scalar**) or a table
(**table-valued**). Unlike a stored procedure, a function can be used
directly inside a `SELECT`, `WHERE`, or `FROM` clause — you never
`EXEC` it separately.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found. (Chapter 5 of that document covers only SQL Server's
*built-in* functions, not functions you write yourself.)

## The three kinds of UDF

| Kind | Returns | Think of it like |
|---|---|---|
| Scalar Function | A single value | A formula/calculation |
| Inline Table-Valued Function (iTVF) | A table, via one `RETURN (SELECT ...)` | A parameterized view |
| Multi-statement TVF (MSTVF) | A table, built across multiple statements | A small procedure that returns a table |

## Files

| File | What it covers |
|---|---|
| `00-setup.sql` | Creates `Departments` and `Employees` (now with `HireDate`). Run this first. |
| `01-scalar-function-years-of-service.sql` | A scalar function used in both a `SELECT` list and a `WHERE` clause; includes a caveat about `DATEDIFF(YEAR, ...)` counting calendar years, not full elapsed years. |
| `02-inline-tvf-employees-by-dept.sql` | An inline table-valued function — a parameterized view, queried with a fixed literal argument. |
| `03-apply-operator.sql` | `CROSS APPLY` / `OUTER APPLY` — calling the same inline TVF once per row of another table, with that row's own column as the parameter. |
| `04-multi-statement-tvf.sql` | A multi-statement TVF building a small summary table across two `INSERT` statements. |
| `05-scalar-udf-performance-note.sql` | Why a scalar function in a `WHERE` clause is a classic performance trap on larger tables, and what SQL Server 2019's Scalar UDF Inlining does (and doesn't) fix. Meant to be observed via Actual Execution Plan, not just run. |

## The most important limitation to know

**A function cannot modify real table data.** No `INSERT`, `UPDATE`,
or `DELETE` against persisted tables, no `TRY...CATCH`, no explicit
transactions, no dynamic SQL. A function can only read and compute —
that restriction is what makes it safe to call from inside a `SELECT`
in the first place.

## Which kind should I reach for?

Prefer an **inline TVF** over a **multi-statement TVF** whenever a
single `SELECT` can express the logic — the query optimizer can
expand an inline TVF the same way it treats a view, while a
multi-statement TVF's return table behaves like an ordinary table
variable (no real statistics), which can mislead the optimizer on
larger data. Reach for a multi-statement TVF only when you genuinely
need multiple steps that one `SELECT` can't express.

## How to run

Run `00-setup.sql` once, then `01` through `05` in order — `03` and
`05` depend on functions created in `01` and `02`.
