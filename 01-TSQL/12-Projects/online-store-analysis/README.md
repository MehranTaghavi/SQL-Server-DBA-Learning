# Online Store Sales Analysis — T-SQL Portfolio Project

A self-contained T-SQL project built as part of the [01-TSQL](.) chapter of the
[SQL-Server-DBA-Learning](https://github.com/MehranTaghavi/SQL-Server-DBA-Learning)
portfolio. It simulates a small online store and answers realistic business
questions using progressively more advanced T-SQL techniques: JOINs,
subqueries, CTEs, and window functions.

## What this demonstrates

| Query | Business question answered | Technique |
|---|---|---|
| 1 | Full order detail (customer, product, quantities, totals) | Multi-table INNER JOIN |
| 2 | Which customers spend above the average customer? | Aggregation + subquery |
| 3 | Monthly revenue and month-over-month change | CTE + `LAG()` |
| 4 | Top spenders per month + running total revenue | Window functions (`RANK()`, `SUM() OVER`) |

## How to run

1. Requires SQL Server 2019+ (SSMS or Azure Data Studio).
2. Run [`01_schema_and_data.sql`](01_schema_and_data.sql) once — it creates a
   disposable `OnlineStoreSample` database, tables, and sample data.
3. Run [`02_analysis_queries.sql`](02_analysis_queries.sql) against the same
   database to see all four analysis queries.

Each script is self-contained and re-runnable — no external files or
downloads are needed.

## Why this project

Real employers care less about knowing individual SQL clauses and more about
whether a candidate can turn a business question into a correct, readable
query. This project is deliberately framed around business questions
("which customers spend the most", "how is revenue trending") rather than
isolated syntax exercises, to make that connection explicit.