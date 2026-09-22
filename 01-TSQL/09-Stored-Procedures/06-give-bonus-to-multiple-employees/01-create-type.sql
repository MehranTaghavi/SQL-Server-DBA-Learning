/* ============================================================
   Exercise 06 - Table-Valued Parameters (TVP)
   Step 1 of 2: the user-defined table type
   ============================================================
   See ../Table-Valued-Parameters-Concept.md for the full theory.

   A TVP's shape must exist as a named, database-level type BEFORE
   any procedure can declare a parameter of that type. This is the
   table-type equivalent of defining a class before instantiating
   it -- CREATE PROCEDURE below will fail if this hasn't been run
   first.
   ============================================================ */

IF TYPE_ID(N'dbo.EmployeeIDList') IS NOT NULL
    DROP TYPE dbo.EmployeeIDList;
GO

CREATE TYPE dbo.EmployeeIDList AS TABLE
(
    EmployeeID INT PRIMARY KEY
);
GO