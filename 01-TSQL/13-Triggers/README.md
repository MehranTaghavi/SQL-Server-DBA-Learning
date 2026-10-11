# Triggers

A **trigger** is code attached to a table that SQL Server runs
automatically when an `INSERT`, `UPDATE` or `DELETE` happens on it —
you never call it yourself. Typical uses: audit logging, archiving
deleted rows, and enforcing rules that a simple constraint can't
express.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found.

## Key ideas

- **`AFTER` trigger** — runs after the statement's changes are made.
- **`INSTEAD OF` trigger** — replaces the statement that fired it;
  the original `INSERT`/`UPDATE`/`DELETE` never actually runs.
- **`inserted` and `deleted`** — special pseudo-tables available
  inside a trigger. `inserted` holds the new version of every
  affected row, `deleted` holds the old version. (An `UPDATE` has
  both; an `INSERT` only has `inserted`; a `DELETE` only has
  `deleted`.)
- **A trigger fires once per statement, not once per row.** One
  `UPDATE` that changes 1,000 rows fires the trigger once, with
  1,000 rows in `inserted`/`deleted`. Triggers must therefore be
  written set-based — see `04-multi-row-pitfall.sql`.
- A trigger runs **inside the same transaction** as the statement
  that fired it: if that statement is rolled back, so is everything
  the trigger did.

## Files

| File | What it covers |
|---|---|
| `00-setup.sql` | Creates `Employees`, `SalaryAudit` and `EmployeeArchive`. Run this first. |
| `01-after-update-audit-trigger.sql` | An `AFTER UPDATE` trigger that logs old/new salary using `inserted` and `deleted`, with `IF UPDATE(Salary)` and a multi-row test. |
| `02-after-delete-archive-trigger.sql` | An `AFTER DELETE` trigger that copies removed rows into an archive table; tested inside a rolled-back transaction. |
| `03-instead-of-trigger-soft-delete.sql` | An `INSTEAD OF DELETE` trigger turning a `DELETE` into a "soft delete" (flag the row inactive). Self-contained. |
| `04-multi-row-pitfall.sql` | The classic bug — a trigger that assumes one row — shown failing, then fixed with a set-based version. Self-contained. |
| `05-managing-triggers.sql` | Listing triggers via `sys.triggers`, and `DISABLE TRIGGER` / `ENABLE TRIGGER`, with before/after evidence. |

## When to be careful

Triggers are powerful but easy to overuse: their logic is invisible
to anyone reading the application code or the table definition,
they add cost to every write on the table, and a slow or failing
trigger slows or fails the statement that fired it. Prefer
constraints for simple rules, and keep trigger bodies short and
set-based.

## How to run

Run `00-setup.sql`, then `01` and `02` in order, then `03` and `04`
(both self-contained), then `05` last — it lists and toggles the
triggers created by the earlier files.
