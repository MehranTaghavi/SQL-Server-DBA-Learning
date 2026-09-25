# JOIN

These standalone exercises demonstrate how to combine related tables while preserving the intended row set. Start with INNER JOIN, compare it with LEFT JOIN, and finish with SELF JOIN for employee-manager relationships.

After INNER, LEFT and SELF JOIN, continue with RIGHT JOIN, FULL OUTER JOIN and CROSS JOIN to see the full picture of how SQL Server can combine two tables.

Pay attention to unmatched rows and to the difference between putting a predicate in `ON` versus `WHERE`.

## Exercises

| File | Topic | What it covers |
|------|-------|-----------------|
| `01-inner-join.sql` | INNER JOIN | Matching rows across two related tables (`Employees`, `Departments`) |
| `02-left-join.sql` | LEFT JOIN | Keeping unmatched rows from the left table — finding employees with no department and departments with no employees |
| `03-self-join.sql` | SELF JOIN | Joining a table to itself to map employees to their managers |
| `04-right-join.sql` | RIGHT JOIN | Keeping unmatched rows from the right table — finding departments with no employees |
| `05-full-outer-join.sql` | FULL OUTER JOIN | Keeping unmatched rows from BOTH sides at once, and comparing row counts with INNER JOIN |
| `06-cross-join.sql` | CROSS JOIN | Producing every possible combination of rows from two tables (the Cartesian product) |

## How to run

Each file is a complete, standalone script. Open it in SSMS (or your SQL Server client of
choice) and run the whole file top to bottom — it drops/creates the tables it needs, so no
external setup is required.