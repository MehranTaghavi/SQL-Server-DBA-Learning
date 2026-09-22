
# Exercise 06 - Table-Valued Parameters (TVP)

A procedure that applies the same percentage bonus to an **entire
list** of employees in one atomic call, using a Table-Valued
Parameter instead of a fragile comma-separated string or a loop of
single-row calls.

See `../Table-Valued-Parameters-Concept.md` for the full theory (what
problem TVPs solve, why `READONLY` is mandatory, performance
characteristics, and common pitfalls).

Uses the sample tables created by `00-setup.sql` (from the `07-CTE`
folder).

## What this exercise demonstrates

| Concept                              | Where it shows up                                                                                                                                                                                          |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User-defined table type              | `01-create-type.sql` — the reusable shape a TVP parameter is declared against                                                                                                                           |
| `READONLY` TVP parameter           | `02-procedure.sql` — mandatory keyword; the parameter can be read/joined but never modified inside the procedure                                                                                        |
| Set-based bulk update                | `02-procedure.sql` — one `UPDATE ... FROM ... JOIN` raises every matching employee's salary, instead of looping row by row                                                                            |
| All-or-nothing validation over a set | `02-procedure.sql` — a `LEFT JOIN` against the TVP finds any ID with no match in `Employees`; if even one is missing, the *entire* call is rejected                                               |
| Reused transaction pattern           | `02-procedure.sql` — the same `SET XACT_ABORT ON` + `TRY...CATCH` + `BEGIN TRANSACTION`/`ROLLBACK` structure from Exercise 04, now protecting a multi-row update instead of a two-statement one |

## Why the validation order matters

The procedure checks, in this exact order, **before** opening a
transaction:

1. Is the list empty?
2. Is `BonusPercent` in range?
3. Does every `EmployeeID` in the list actually exist?

Only after all three pass does `BEGIN TRANSACTION` run. This means an
invalid call of any kind never touches the transaction log at all —
there is nothing to roll back, because nothing was ever opened.
Test 05 specifically exists to prove this isn't just a theoretical
claim: it sends two perfectly valid `EmployeeID`s alongside one
invalid one, and confirms the two valid employees are **not**
quietly given the bonus while the invalid one is skipped. The whole
list either succeeds together, or fails together.

## Files

| File                                     | What it does                                                                                                                   |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `01-create-type.sql`                   | Creates the`dbo.EmployeeIDList` table type. Run this first.                                                                  |
| `02-procedure.sql`                     | Creates`dbo.GiveBonusToMultipleEmployees`. Run this second.                                                                  |
| `03-test-successful-call.sql`          | Valid call with 3 employees: confirms all three salaries rise together.                                                        |
| `04-test-invalid-bonus-percent.sql`    | `BonusPercent = 60` (out of range): confirms rejection before any transaction opens.                                         |
| `05-test-invalid-employee-in-list.sql` | A list with 2 valid IDs + 1 nonexistent ID: confirms the all-or-nothing rule — the 2 valid employees are also left untouched. |
| `06-test-empty-list.sql`               | An empty TVP: confirms the procedure's own explicit check catches it (a TVP with zero rows is not an error by itself).         |

## Run order

1. Run `00-setup.sql` (from `07-CTE`) if the sample tables don't exist yet.
2. Run `01-create-type.sql`.
3. Run `02-procedure.sql`.
4. Run `03`, `04`, `05`, and `06` in any order — each is self-contained.
