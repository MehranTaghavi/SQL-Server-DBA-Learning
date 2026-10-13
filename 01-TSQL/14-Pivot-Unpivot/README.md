# PIVOT and UNPIVOT

**PIVOT** rotates rows into columns — the distinct values of one
column become column headings, and an aggregate fills the cells.
**UNPIVOT** does the reverse, turning columns back into rows. Both
are used to reshape data for reports and analysis.

This topic is not covered by the project's primary T-SQL reference
document (`T_SQL_1.pdf`) — it was searched for specifically and not
found.

## Files

| File | What it covers |
|---|---|
| `00-setup.sql` | Creates the `Sales` table (with a duplicate Q1 row to aggregate and a missing West/Q3 row to produce a `NULL`). Run this first. |
| `01-pivot-basic.sql` | A basic `PIVOT`: regions as rows, quarters as columns, `SUM(Amount)` in the cells. |
| `02-pivot-null-handling.sql` | Replacing the `NULL` cells a `PIVOT` produces with `0` using `ISNULL`. |
| `03-pivot-extra-column-pitfall.sql` | The classic mistake: an extra source column (`SaleID`) silently becomes a grouping column, so nothing is aggregated. Shown wrong, then fixed. |
| `04-unpivot-basic.sql` | `UNPIVOT` turning a wide table back into rows; shows that `NULL` rows are dropped and that `UNPIVOT` is not a perfect inverse of `PIVOT`. Self-contained. |
| `05-pivot-vs-conditional-aggregation.sql` | The same crosstab built with `SUM(CASE WHEN ...)`, which allows several aggregates and custom defaults. |

## Key points

- `PIVOT` needs the column list written out explicitly
  (`IN (Q1, Q2, Q3, Q4)`). If the values aren't known in
  advance, the query has to be built with dynamic SQL.
- `PIVOT` groups by **every** source column that is not the pivoted
  or aggregated column — so the derived table should contain only the
  row-label column(s), the pivoted column, and the aggregated column.
- A pivoted cell with no source rows is `NULL`, not `0`.
- `UNPIVOT` silently discards `NULL` values and cannot restore detail
  that an earlier aggregation already combined.

## How to run

Run `00-setup.sql` once, then `01` through `05` in any order. `04` is
self-contained after `00`: it builds its own `SalesWide` table.
