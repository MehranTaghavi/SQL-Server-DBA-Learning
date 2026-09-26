# Transaction Management and Structured Error Handling in T-SQL Stored Procedures

## Abstract

This document examines transaction control in Microsoft SQL Server
(T-SQL), with emphasis on the combined use of explicit transactions
(`BEGIN TRANSACTION` / `COMMIT TRANSACTION` / `ROLLBACK TRANSACTION`)
and structured exception handling (`TRY...CATCH`) inside stored
procedures. It covers the theoretical basis (the Atomicity property
of ACID), the mechanics of SQL Server's transaction model, common
implementation pitfalls, and performance implications. This topic is
not covered by the primary T-SQL reference document (`T_SQL_1.pdf`)
used elsewhere in this learning project; the reference document
explicitly identifies transaction management combined with
`TRY...CATCH` as material for "a separate, dedicated chapter"
(T_SQL_1.pdf, p. 46) and does not develop it further. The present
document is therefore compiled independently from general SQL Server
documentation and practice, to close that gap.

## 1. Introduction

Stored procedures frequently perform more than one data-modifying
statement in sequence — for example, inserting a record and updating
a related record in the same logical operation. When such an
operation partially succeeds (one statement commits its effect while
a later statement fails), the database is left in an inconsistent
state that does not correspond to any valid business event. Explicit
transactions exist to prevent this class of failure.

## 2. Theoretical Background: Atomicity

Atomicity is one of the four ACID properties (Atomicity, Consistency,
Isolation, Durability) that a relational database engine guarantees
for a transaction. It requires that a transaction's effects are
applied in their entirety or not at all — there is no partially
applied intermediate state visible to other sessions or persisted to
disk. SQL Server enforces atomicity through its transaction log: every
modification is recorded before it is applied to data pages, which
allows the engine to undo (roll back) an incomplete transaction.

## 3. Transaction Control Statements

| Statement | Effect |
|---|---|
| `BEGIN TRANSACTION` | Starts an explicit transaction; increments `@@TRANCOUNT` by 1 |
| `COMMIT TRANSACTION` | Decrements `@@TRANCOUNT` by 1; when it reaches 0, all changes since the outermost `BEGIN TRANSACTION` become permanent |
| `ROLLBACK TRANSACTION` | Undoes all changes since the outermost `BEGIN TRANSACTION`, regardless of nesting depth, and resets `@@TRANCOUNT` to 0 |
| `@@TRANCOUNT` | System function returning the number of currently open (possibly nested) transactions on the connection |

By default, SQL Server operates in **autocommit mode**: each
individual statement is its own implicit transaction. `BEGIN
TRANSACTION` suspends autocommit mode until a matching `COMMIT` or a
`ROLLBACK` occurs.

### 3.1 Nested Transactions

SQL Server allows `BEGIN TRANSACTION` to be issued while a transaction
is already open, incrementing `@@TRANCOUNT` further. This is commonly
misunderstood: an inner `COMMIT TRANSACTION` does **not** independently
commit the inner unit of work — it only decrements `@@TRANCOUNT`.
Only the commit that brings `@@TRANCOUNT` to 0 performs a real commit.
Conversely, a `ROLLBACK TRANSACTION` issued at any nesting level
undoes the entire transaction back to the outermost `BEGIN
TRANSACTION`, irrespective of how many `BEGIN TRANSACTION` statements
were nested inside it.

## 4. `SET XACT_ABORT ON` and Error Propagation

By default (`XACT_ABORT OFF`), certain run-time errors inside a
transaction do not automatically terminate the transaction or the
batch — execution may continue past a failed statement, or the
transaction may be left open in an inconsistent state. `SET
XACT_ABORT ON` changes this behavior: when a run-time error occurs,
the entire transaction is automatically rolled back and the batch
stops. This setting is considered a required practice for any
procedure combining explicit transactions with `TRY...CATCH`: without
it, the `CATCH` block may be reached with a transaction state that is
inconsistent with what the developer assumed.

## 5. `TRY...CATCH` Structure and the `THROW` Statement

`BEGIN TRY ... END TRY` / `BEGIN CATCH ... END CATCH` provides
structured exception handling: if any statement inside the `TRY`
block raises a run-time error at severity level 11-19 (compile
errors and severity 20+ are not caught), control transfers immediately
to the `CATCH` block. Inside `CATCH`, the `THROW` statement (used with
no arguments) re-raises the original error — including its message
text, severity, and state — to the calling session, without altering
or suppressing the original diagnostic information. `THROW` with
explicit arguments (`THROW error_number, message, state`) can be used
to raise a custom application-level error, typically after a
validation check has failed.

### 5.1 Recommended Pattern

```sql
CREATE OR ALTER PROCEDURE dbo.ExampleProcedure
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        -- validation checks that should prevent the transaction
        -- from ever being opened go here

        BEGIN TRANSACTION;

        -- one or more data-modifying statements

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
```

Validation that can be evaluated without side effects (existence
checks, range checks) is placed before `BEGIN TRANSACTION`, so that an
invalid call never opens a transaction in the first place. The
`@@TRANCOUNT > 0` check before `ROLLBACK` is necessary because the
`CATCH` block may also be reached by an error raised before any
transaction was opened.

## 6. Common Implementation Pitfalls

1. Omitting `SET XACT_ABORT ON`, leading to transactions that are not
   reliably rolled back on error.
2. Calling `ROLLBACK TRANSACTION` without first checking
   `@@TRANCOUNT`, which raises an additional error if no transaction
   is open.
3. Assuming an inner `COMMIT TRANSACTION` in a nested transaction
   independently persists the inner unit of work.
4. Leaving a transaction open on an unhandled code path (e.g., an
   early `RETURN` inside `TRY` before `COMMIT`), which holds locks
   until the connection is closed or the transaction is otherwise
   resolved.
5. Performing slow or blocking operations (external calls, waiting on
   user input) while a transaction is open.

## 7. Performance Considerations

An open transaction holds locks on the rows and pages it has
modified until it is committed or rolled back. The longer a
transaction remains open, the longer those locks are held, increasing
the likelihood of blocking other concurrent sessions and, in more
severe cases, deadlocks. Long-running transactions also increase
transaction log growth, since log records cannot be truncated while a
transaction referencing them is still open. The general
recommendation is to keep the statements between `BEGIN TRANSACTION`
and `COMMIT`/`ROLLBACK` as short and as free of unrelated logic as
possible.

## 8. Review Questions

1. What is the difference in effect between `COMMIT TRANSACTION` and
   `ROLLBACK TRANSACTION`, and what role does `@@TRANCOUNT` play in
   determining that effect?
2. Why is `SET XACT_ABORT ON` considered necessary when combining
   explicit transactions with `TRY...CATCH`?
3. Explain, precisely, how nested `BEGIN TRANSACTION`/`COMMIT
   TRANSACTION` pairs behave in SQL Server, and why this differs from
   what the term "nested transaction" might suggest.
4. What is the functional difference between `THROW` (no arguments)
   and `RAISERROR`?

## References

- T_SQL_1.pdf (personal reference document), Chapter 6, p. 46 —
  identifies transaction management combined with `TRY...CATCH` as
  out of scope for that document.
- Microsoft Learn — *Transactions (Transact-SQL)*
- Microsoft Learn — *TRY...CATCH (Transact-SQL)*
- Microsoft Learn — *SET XACT_ABORT (Transact-SQL)*