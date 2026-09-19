
# Exercise 04 - Transactions + TRY...CATCH

An atomic, two-step stored procedure: placing an order and applying a
salary bonus together, using an explicit transaction with `SET XACT_ABORT ON` and `TRY...CATCH` so that either both changes happen
or neither does.

See `../Transactions-and-TryCatch-Concept.md` for the underlying
theory (Atomicity, `@@TRANCOUNT`, `XACT_ABORT`, nested transaction
semantics).

Uses the sample tables created by `00-setup.sql` (from the `07-CTE`
folder).

## Files

| File                                  | What it does                                                                                                |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `01-procedure.sql`                  | Creates`dbo.PlaceOrderWithBonus`. Run this first.                                                         |
| `02-test-successful-call.sql`       | Valid call: confirms the order is inserted and the salary raised together.                                  |
| `03-test-invalid-employee.sql`      | Invalid`EmployeeID`: confirms `THROW` fires and the transaction rolls back with no partial insert.      |
| `04-test-invalid-bonus-percent.sql` | Invalid`BonusPercent`: confirms validation rejects the call before `BEGIN TRANSACTION` is ever reached. |

## Run order

1. Run `00-setup.sql` (from `07-CTE`) if the sample tables don't exist yet.
2. Run `01-procedure.sql`.
3. Run `02`, `03`, and `04` in any order -- each is self-contained.
