# RETURN with Status Code

> This topic completes Chapter 09 (Stored Procedures).

## 1. What is it?

`RETURN [integer]` immediately exits a procedure (or batch/function) and passes a **single integer**
back to the caller as a "status code." Any code written after `RETURN` in the same procedure does not
execute.

## 2. Why does it exist?

Before `TRY...CATCH` existed, this was the only way for a procedure to say "what happened." It's still
useful today for normal, expected outcomes (not real errors).

Classic example: "No employee found with this ID" is not a program error — it's just a status. For
this case, `RETURN` is more appropriate than `THROW`, because `THROW` should be reserved for truly
exceptional conditions (invalid input, business rule violations).

## 3. How does it work?

```sql
CREATE OR ALTER PROCEDURE dbo.SomeProc
AS
BEGIN
    IF @SomeCondition
        RETURN 1;   -- immediate exit, status code 1

    -- this line only runs if the RETURN above did not execute
    PRINT 'Continuing work';
    RETURN 0;       -- success
END;
```

Calling it and capturing the status code:

```sql
DECLARE @Status INT;
EXEC @Status = dbo.SomeProc;
PRINT @Status;   -- the returned value is available right here
```

## 4-5. Common convention for codes

| Code | Meaning |
|------|---------|
| `0` | Complete success |
| `1` | Normal status but "not done" (e.g., not found) |
| Negative (e.g. `-1`) | Invalid input |

## 6. Key difference from OUTPUT and from THROW

- `RETURN` can only return a single integer — not a string, not multiple values. To return real data
  (like a new `EmployeeID`), you must use an `OUTPUT` parameter, not `RETURN`.
- `RETURN` is for expected statuses, `THROW` is for real errors. If an input parameter is fundamentally
  invalid (e.g., a negative percentage), that's a bug in how the procedure was called → `THROW`. But
  "record not found" is a normal part of the workflow → `RETURN`.

## 7. Common mistakes

- Forgetting to capture the return value on the caller's side (`EXEC dbo.Proc;` without `@Status =`) —
  the status code is silently discarded.
- Trying to return anything other than an integer.
- Using `RETURN` to pass real data instead of `OUTPUT` or `SELECT`.
- Writing code after `RETURN` assuming it will execute.

## 8-9. Performance and interviews

There's nothing special from a performance standpoint; but this exact question comes up frequently in
interviews: "What's the difference between `RETURN` and an `OUTPUT` parameter?" The answer is exactly
what's covered in section 6.

## 10. Exercise

Exercise folder: [`07-return-status-code/`](./07-return-status-code/)
- Exercise file: [`07-return-status-code/exercise.sql`](./07-return-status-code/exercise.sql)
- Solution: [`07-return-status-code/solution.sql`](./07-return-status-code/solution.sql)