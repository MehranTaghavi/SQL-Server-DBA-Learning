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
| `07-running-total.sql`                          | SUM() OVER + window frame | Running total of order amounts per employee, and company-wide                                           |
| `08-ntile-salary-quartiles.sql`                 | NTILE                     | Splitting employees into salary quartiles, and using NTILE for paging                                  |

Each exercise file contains the solution query.
