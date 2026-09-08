# Common Table Expressions (CTE)

These standalone exercises move from simple CTEs and aggregation to window functions, pagination, and recursive organizational queries.

Run `00-setup.sql` once before exercises `02` through `10`. The setup creates the sample `Departments`, `Employees`, and `Orders` tables used by the exercises.

The existing salary-gap example remains available as `01-salary-gap-with-cte.sql`.

## Exercises

| File | Topic | What it covers |
|------|-------|----------------|
| `00-setup.sql` | Sample database | Creates and seeds the tables used by the CTE exercises |
| `01-salary-gap-with-cte.sql` | Salary gap | Finds employees whose salary is more than 10% below their department average |
| `02-average-salary.sql` | Simple CTE | Employees earning more than the company-wide average salary |
| `03-department-count.sql` | CTE + aggregation | Departments with more than two employees |
| `04-employee-sales.sql` | CTE + JOIN | Total sales for every employee, including employees with no orders |
| `05-highest-department-average.sql` | Chained CTEs | Department with the highest average salary |
| `06-top-two-by-department.sql` | CTE + ROW_NUMBER | Two highest-paid employees in each department |
| `07-pagination.sql` | CTE + pagination | The second page of employees, three rows per page |
| `08-date-series-recursive.sql` | Recursive CTE | Generates every date from 2023-01-01 through 2023-01-10 |
| `09-employee-hierarchy.sql` | Recursive hierarchy | Finds Reza Karimi's direct and indirect subordinates |
| `10-subordinate-summary.sql` | Recursive CTE + aggregation | Counts subordinates and sums their salaries for every employee |

Each exercise file contains the solution query. The recursive exercises use `OPTION (MAXRECURSION 100)` where a recursion limit is relevant.

