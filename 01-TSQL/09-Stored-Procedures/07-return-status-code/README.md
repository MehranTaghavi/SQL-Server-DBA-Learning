# Exercise 07 — RETURN with Status Code

Concept/theory for this topic: [`../Return-Status-Code-Concept.md`](../Return-Status-Code-Concept.md)

## Task

Write the procedure `dbo.TryGiveRaise`:

- **Parameters:** `@EmployeeID INT`, `@RaisePercent DECIMAL(5,2)`
- **Logic:**
  1. If `@RaisePercent` is outside the 0–50 range → invalid input → `THROW`.
  2. If `@EmployeeID` is not found in `Employees` → normal status → `RETURN 1`.
  3. Otherwise → apply the raise → `RETURN 0`.

## Files

- [`exercise.sql`](./exercise.sql) — starter file, write your solution here first.
- [`solution.sql`](./solution.sql) — reference solution, check after you're done.

## How to test

```sql
DECLARE @Status INT;
EXEC @Status = dbo.TryGiveRaise @EmployeeID = 3, @RaisePercent = 10;
PRINT @Status;   -- expected: 0

EXEC @Status = dbo.TryGiveRaise @EmployeeID = 9999, @RaisePercent = 10;
PRINT @Status;   -- expected: 1 (no error)
```