# 10 - Set Operators

This section introduces T-SQL Set Operators, which allow you to combine or compare the results of two or more independent queries into a single result set.

## Operators Covered
1. **UNION:** Combines the results of two queries into a single result set and automatically removes all duplicate rows.
2. **UNION ALL:** Combines the results of two queries but retains all duplicate rows. It performs significantly faster than `UNION` because it skips the deduplication and sorting phase.
3. **INTERSECT:** Acts like a logical "AND". It returns only the distinct rows that appear in both the first and second queries.
4. **EXCEPT:** Acts like a logical subtraction. It returns distinct rows from the top query that do NOT appear in the bottom query.

## Core Rules
- **Matching Columns:** All queries involved in a set operation must have the exact same number of columns in their `SELECT` lists.
- **Data Types:** The corresponding columns in all queries must have compatible data types (or be explicitly cast).
- **Column Names:** The column names in the final result set are always determined by the **first** query.
- **ORDER BY:** You cannot use `ORDER BY` inside the individual queries. It can only be placed once, at the very end of the entire statement, to sort the final combined output.
