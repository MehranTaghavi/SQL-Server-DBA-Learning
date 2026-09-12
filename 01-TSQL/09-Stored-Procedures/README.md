
# Stored Procedures

These standalone exercises cover writing, parameterizing, and safely
executing stored procedures in T-SQL — a topic beyond the base
Microsoft Learn path, alongside CTE and Window Functions.

They reuse the same sample database as the CTE exercises. Run
`00-setup.sql` from the `07-CTE` folder once before these exercises if
the `Departments`, `Employees`, and `Orders` tables don't already
exist.

## Exercises

| File                                   | Topic                                | What it covers                                                                                                         |
| -------------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `01-get-employees-by-department.sql` | Basic procedure + optional parameter | A reusable procedure with one optional input parameter, returning either one department's employees or all of them     |
| `02-add-employee-with-output.sql`    | Input parameters + OUTPUT parameter  | Inserting a new employee and returning its new`EmployeeID` to the caller without a separate SELECT                   |
| `03-safe-update-salary.sql`          | TRY...CATCH + validation             | Safely updating an employee's salary, rejecting invalid values with a custom error instead of letting bad data through |

Each exercise file contains both the `CREATE PROCEDURE` statement and
one or more `EXEC` calls demonstrating how to use it.
