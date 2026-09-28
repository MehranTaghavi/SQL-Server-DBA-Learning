# Exercise 07 - RETURN Status Codes

A procedure that gives an employee a raise, using two different
signaling mechanisms for two different kinds of outcome: `THROW` for
a genuinely invalid call (an out-of-range percentage), and a
`RETURN` status code for a normal, expected outcome that isn't an
error (the employee simply doesn't exist).

See `../Return-Status-Code-Concept.md` for the full theory (RETURN
vs. OUTPUT parameters, RETURN vs. THROW, and common pitfalls).

Uses the sample tables created by `00-setup.sql` (from the `07-CTE`
folder).

## Files

| File | What it does |
|---|---|
| `01-procedure.sql` | Creates `dbo.TryGiveRaise`. Run this first. |
| `02-test-successful-call.sql` | Valid call: confirms the raise is applied and `RETURN 0` is captured. |
| `03-test-invalid-percent.sql` | `RaisePercent = 70` (out of range): confirms this raises via `THROW` and stops the batch -- `@Status` is never assigned. |
| `04-test-employee-not-found.sql` | A nonexistent `EmployeeID`: confirms this returns status `1` with **no exception** -- the batch continues normally, unlike Test 03. |

## Why Test 03 and Test 04 behave so differently

This is the core lesson of the exercise: Test 03's invalid percentage
stops the batch entirely (an uncaught `THROW`), while Test 04's
missing employee does not stop anything -- it just leaves a `1` in
`@Status` for the caller to check. Comparing these two side by side
is the fastest way to see why `RETURN` and `THROW` are not
interchangeable.

## Run order

1. Run `00-setup.sql` (from `07-CTE`) if the sample tables don't exist yet.
2. Run `01-procedure.sql`.
3. Run `02`, `03`, and `04` in any order — each is self-contained.