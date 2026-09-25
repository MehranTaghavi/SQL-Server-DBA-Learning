# Stored Procedures

**Status: in progress.** Covers optional parameters, OUTPUT
parameters, error handling, transactions, dynamic SQL, and
table-valued parameters so far. `RETURN` with a status code is still
pending before this chapter is considered complete.

These standalone exercises cover writing, parameterizing, and safely
executing stored procedures in T-SQL — a topic beyond the base
Microsoft Learn path, alongside CTE and Window Functions.

They reuse the same sample database as the CTE exercises. Run
`00-setup.sql` from the `07-CTE` folder once before these exercises if
the `Departments`, `Employees`, and `Orders` tables don't already
exist.

## Exercises

| File / Folder                              | Topic                                | What it covers                                                                                                                                                                                                                                                                |
| ------------------------------------------ | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `01-get-employees-by-department.sql`     | Basic procedure + optional parameter | A reusable procedure with one optional input parameter, returning either one department's employees or all of them                                                                                                                                                            |
| `02-add-employee-with-output.sql`        | Input parameters + OUTPUT parameter  | Inserting a new employee and returning its new `EmployeeID` to the caller without a separate SELECT                                                                                                                                                                          |
| `03-safe-update-salary.sql`              | TRY...CATCH + validation             | Safely updating an employee's salary, rejecting invalid values with a custom error instead of letting bad data through                                                                                                                                                        |
| `04-place-order-with-bonus-transaction/` | Explicit transactions + TRY...CATCH  | Placing an order and applying a salary bonus as a single atomic operation. Split into a procedure file plus one file per test scenario — see the folder's own README.                                                                                                        |
| `05-search-employees-dynamic-sort/`      | Dynamic SQL (`sp_executesql`)        | A search procedure with optional filters and a user-selectable sort column, built safely with parameterized filter values and a whitelisted + `QUOTENAME()`-wrapped sort column. Split into a procedure file plus one file per test scenario — see the folder's own README. |
| `06-give-bonus-to-multiple-employees/`   | Table-Valued Parameters (TVP)        | Applying a bonus to an entire list of employees in one atomic call, using a `READONLY` TVP and an all-or-nothing validation rule over the whole set. Split into a table-type file, a procedure file, and one file per test scenario — see the folder's own README.          |

Each exercise file contains both the `CREATE PROCEDURE` statement and
one or more `EXEC` calls demonstrating how to use it, except Exercises
04, 05, and 06, where the procedure and its test scenarios are split
across separate files (see each folder's own README).

## Concept documentation

- `Transactions-and-TryCatch-Concept.md` — the theory behind Exercise
  04: the Atomicity property, `BEGIN TRANSACTION`/`COMMIT`/`ROLLBACK`,
  `@@TRANCOUNT`, `SET XACT_ABORT ON`, nested transaction semantics,
  and common pitfalls.
- `Dynamic-SQL-Concept.md` — the theory behind Exercise 05: `EXEC()`
  vs. `sp_executesql`, why value parameterization prevents SQL
  Injection while identifiers (table/column names) cannot be
  parameterized the same way, the whitelist + `QUOTENAME()` pattern,
  and plan-cache performance implications.
- `Table-Valued-Parameters-Concept.md` — the theory behind Exercise
  06: what problem TVPs solve, how user-defined table types and
  `READONLY` parameters work, their constraints, and performance
  characteristics compared to row-by-row calls and delimited strings.

None of these three topics is covered by the project's primary T-SQL
reference document — it either explicitly flags transaction
management as material for a separate chapter, or simply does not
mention Dynamic SQL / TVPs at all — these three files fill that gap.