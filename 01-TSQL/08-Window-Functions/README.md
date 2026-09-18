# Window Functions

These standalone exercises cover the basic ranking window functions:
`ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.

They reuse the same sample database as the CTE exercises. Run
`00-setup.sql` from the CTE folder once before these exercises if the
`Departments`, `Employees`, and `Orders` tables don't already exist.

## Exercises

| File                                              | Topic                     | What it covers                                                                                          |
| ------------------------------------------------- | ------------------------- | ------------------------------------------------------------------------------------------------------- |
| `01-row-number-salary-ranking.sql`              | ROW_NUMBER                | Unique company-wide salary ranking across all employees                                                 |
| `02-row-number-top-employee-per-department.sql` | ROW_NUMBER + PARTITION BY | Highest-paid employee in each department                                                                |
| `03-rank-department-headcount.sql`              | RANK                      | Departments ranked by employee headcount, showing how RANK() handles ties and leaves gaps               |
| `04-dense-rank-seniority-groups.sql`            | DENSE_RANK                | Employees grouped into seniority tiers by hire year, showing how DENSE_RANK() handles ties without gaps |
| `05-row-number-vs-rank-vs-dense-rank.sql`       | Comparison                | ROW_NUMBER, RANK, and DENSE_RANK side by side on the same ordering                                      |
| `06-lag-lead-previous-order.sql`                | LAG / LEAD                | Previous and next order amount for each employee, without a self join                                  |
| `07-running-total.sql`                          | SUM() OVER + window frame | Running total of order amounts per employee, and company-wide                                          |
| `08-ntile-salary-quartiles.sql`                 | NTILE                     | Splitting employees into salary quartiles, and using NTILE for paging                                   |
| `09-monthly-sales-growth-report.sql` | CTE + GROUP BY + LAG + RANK | A realistic BI-style report: month-over-month sales growth percentage, company-wide and per employee |
| `10-first-value-last-value-moving-average.sql` | FIRST_VALUE / LAST_VALUE + window frame | First and most-recent order amount per employee, the LAST_VALUE default-frame trap, and a 2-order moving average |

Exercise 09 goes a step further by first aggregating data with
GROUP BY inside a CTE, then applying window functions on top of
the aggregated result -- the pattern used in real sales and BI
reports.

Exercise 10 focuses on a frame-related trap that is easy to miss:
`LAST_VALUE()` without an explicit `ROWS`/`RANGE` clause silently
defaults to a frame that ends at the current row, so it never
actually returns the partition's last value unless the frame is
extended to `CURRENT ROW AND UNBOUNDED FOLLOWING`. It also adds a
fixed-size moving average, as opposed to the unbounded running
total from Exercise 07.