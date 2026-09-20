/* ============================================================
   Test 02 - Combined filters, non-default sort column
   ============================================================
   Run 01-procedure.sql first.

   Goal: Confirm that both optional filters apply together, and
   that a non-default, whitelisted sort column is honored.
   ============================================================ */

EXEC dbo.SearchEmployeesDynamicSort
    @DepartmentID = 1,           -- IT
    @MinSalary    = 12000000,
    @SortColumn   = 'LastName';

-- ------------------------------------------------------------
-- Expected result: 3 rows (IT employees with Salary >= 12,000,000),
--   sorted alphabetically by LastName:
--     Sara Ahmadi     (18,000,000)
--     Mina Hosseini   (12,000,000)
--     Ali Rezaei      (25,000,000)
--   Sara and Mina appear before Ali only because 'A' and 'H'
--   sort before 'R' -- this row order has nothing to do with
--   salary or hire date.
-- ------------------------------------------------------------