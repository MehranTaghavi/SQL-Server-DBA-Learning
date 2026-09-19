# Stored Procedures

These standalone exercises cover writing, parameterizing, and safely
executing stored procedures in T-SQL — a topic beyond the base
Microsoft Learn path, alongside CTE and Window Functions.

They reuse the same sample database as the CTE exercises. Run
`00-setup.sql` from the `07-CTE` folder once before these exercises if
the `Departments`, `Employees`, and `Orders` tables don't already
exist.

## Exercises

| File / Folder                              | Topic                                | What it covers                                                                                                                                                                                                                    |
| ------------------------------------------ | ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `01-get-employees-by-department.sql`     | Basic procedure + optional parameter | A reusable procedure with one optional input parameter, returning either one department's employees or all of them                                                                                                                |
| `02-add-employee-with-output.sql`        | Input parameters + OUTPUT parameter  | Inserting a new employee and returning its new`EmployeeID` to the caller without a separate SELECT                                                                                                                              |
| `03-safe-update-salary.sql`              | TRY...CATCH + validation             | Safely updating an employee's salary, rejecting invalid values with a custom error instead of letting bad data through                                                                                                            |
| `04-place-order-with-bonus-transaction/` | Explicit transactions + TRY...CATCH  | Placing an order and applying a salary bonus as a single atomic operation. Split into a procedure file plus one file per test scenario (successful call, invalid employee, invalid bonus percent) — see the folder's own README. |

Each exercise file contains both the `CREATE PROCEDURE` statement and
one or more `EXEC` calls demonstrating how to use it, except Exercise
04, where the procedure and its test scenarios are split across
separate files (see `04-place-order-with-bonus-transaction/README.md`).

## Concept documentation

`Transactions-and-TryCatch-Concept.md` is a standalone write-up of the
theory behind Exercise 04: the Atomicity property, `BEGIN TRANSACTION`/`COMMIT`/`ROLLBACK`, `@@TRANCOUNT`, `SET XACT_ABORT ON`,
nested transaction semantics, and common pitfalls. This topic is not
covered by the project's primary T-SQL reference document, which
explicitly flags it as material for a separate chapter — this file
fills that gap.
