
# Resources

Shared reference material used across multiple chapters of this
repository — not a chapter itself.

## Files

| File            | Used by                                                                                               | Notes                                                                                                                                                                                                                                                                                                                                    |
| --------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `T_SQL_1.pdf` | `01-TSQL` (primarily Chapters covering built-in functions, window functions, and stored procedures) | Personal T-SQL reference document. Exercise files that draw on it cite the relevant chapter/section/page in their header comments. Topics not covered by this document (e.g. explicit transactions combined with`TRY...CATCH`) are documented separately — see `01-TSQL/09-Stored-Procedures/Transactions-and-TryCatch-Concept.md`. |

## Why this lives here instead of inside `01-TSQL`

The document is referenced by exercises across more than one chapter
folder, and future chapters (e.g. `08-Performance-Tuning`) may cite it
as well. Keeping shared reference material at the repository root
avoids duplicating it into, or arbitrarily assigning it to, a single
chapter folder.
