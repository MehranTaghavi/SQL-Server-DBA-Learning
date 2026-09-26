# Table-Valued Parameters (TVP) in T-SQL

## Abstract

This document explains Table-Valued Parameters (TVP) in Microsoft SQL
Server: what problem they solve, how they are declared and consumed,
and the constraints and performance characteristics that follow from
their design. This topic is not covered by the primary T-SQL
reference document (`T_SQL_1.pdf`) used elsewhere in this learning
project; it was searched for specifically and found absent. The
present document is compiled independently from general SQL Server
documentation and practice.

## 1. Introduction

A stored procedure parameter is ordinarily scalar: one `INT`, one
`NVARCHAR`, one `DATE`. Many real operations, however, act on a *set*
of values at once — for example, applying the same change to a list
of specific rows chosen by the caller. Table-Valued Parameters,
introduced in SQL Server 2008, allow an entire table (any number of
rows, one or more columns) to be passed into a stored procedure or
function as a single parameter.

## 2. The Problem TVPs Solve

Before TVPs existed, passing a set of values into a procedure
required one of three inferior approaches:

1. **Row-by-row calls**: invoke the procedure once per value. This
   multiplies network round-trips and per-call overhead by the size
   of the set.
2. **Delimited strings**: concatenate values into a string (e.g.
   `'1,3,5,9'`) and parse it inside the procedure with string
   functions or a splitter function. This is fragile, hard to
   validate, and defeats query plan reuse.
3. **XML parameters**: pass an XML document and shred it with
   `.nodes()`/`.value()`. Functionally workable, but verbose and
   comparatively slow to parse.

A TVP replaces all three with a native, strongly-typed table passed
directly as a parameter.

## 3. Declaring and Using a TVP

### 3.1 Step One: Define a User-Defined Table Type

A TVP's shape must be declared once, at the database level, as a
**user-defined table type**:

```sql
CREATE TYPE dbo.EmployeeIDList AS TABLE
(
    EmployeeID INT PRIMARY KEY
);
```

This is a reusable schema object — like a table definition without a
table. Any procedure, in this database, may declare a parameter of
this type.

### 3.2 Step Two: Declare the Parameter as READONLY

```sql
CREATE OR ALTER PROCEDURE dbo.SomeProcedure
    @IDs dbo.EmployeeIDList READONLY
AS
BEGIN
    SELECT * FROM @IDs;
END;
```

The `READONLY` keyword is **mandatory** for every TVP parameter.
Omitting it is a compile-time error. This is not an arbitrary
restriction: SQL Server does not materialize a TVP as an ordinary
modifiable table variable inside the procedure — it is a read-only,
pre-constructed row set, comparable in spirit to how the query
optimizer treats a system-provided table.

### 3.3 Step Three: Populate and Pass It from the Caller

```sql
DECLARE @MyIDs dbo.EmployeeIDList;
INSERT INTO @MyIDs (EmployeeID) VALUES (1), (3), (5);

EXEC dbo.SomeProcedure @IDs = @MyIDs;
```

Inside the procedure, `@IDs` behaves like any other table for
`SELECT`, `JOIN`, and `EXISTS`/`NOT EXISTS` purposes — it simply
cannot be the target of `INSERT`, `UPDATE`, or `DELETE`.

## 4. Constraints

- A TVP parameter must be declared `READONLY`; SQL Server rejects the
  procedure definition otherwise.
- A TVP parameter cannot be the target of `INSERT`, `UPDATE`, or
  `DELETE` statements inside the procedure body.
- The underlying user-defined table type must already exist in the
  database before any procedure referencing it can be created.
- A table type can have a `PRIMARY KEY`, `UNIQUE`, and `CHECK`
  constraints, just like an ordinary table definition — these are
  enforced when rows are inserted into the table variable by the
  caller, before the procedure is ever invoked.

## 5. Performance Characteristics

Passing an entire set in a single call removes the network
round-trip cost of row-by-row invocation, and avoids the query-plan
fragmentation caused by dynamically-sized `IN (...)` lists (each
distinct list length or content can otherwise produce a distinct,
non-reusable execution plan). For sets ranging from a handful of rows
to several thousand, a TVP is generally the most practical mechanism
available inside ordinary procedural logic.

For very large sets (hundreds of thousands of rows or more), TVPs
are not the fastest available mechanism — `BULK INSERT` or the
client-side `SqlBulkCopy` API bypass row-by-row parameter binding
entirely and are preferred at that scale. Additionally, a table type
without a primary key or index on a large TVP can force a full scan
when it is joined against another table; declaring appropriate keys
in the `CREATE TYPE` definition (as done in Section 3.1) mitigates
this.

## 6. Common Implementation Pitfalls

1. Omitting `READONLY`, causing the procedure to fail to compile.
2. Attempting to modify the TVP parameter inside the procedure body.
3. Referencing a table type in `CREATE PROCEDURE` before it has been
   created with `CREATE TYPE`.
4. Passing a large, unindexed TVP and being surprised by a table scan
   in the execution plan where a seek was expected.
5. Assuming a TVP is transactional in the same sense as regular
   table data — a table type has no persistent storage of its own; it
   exists only for the duration of the batch/connection that declared
   the variable.

## 7. Review Questions

1. Why must a TVP parameter be declared `READONLY`?
2. What three approaches did developers use to pass sets of values
   into stored procedures before TVPs were introduced, and what did
   each cost?
3. At what data-volume threshold does a TVP typically stop being the
   preferred mechanism, and what replaces it?
4. Where are constraints such as `PRIMARY KEY` on a user-defined
   table type enforced — inside the called procedure, or before it?

## References

- T_SQL_1.pdf (personal reference document) — searched specifically
  for Table-Valued Parameter / `CREATE TYPE ... AS TABLE` content;
  not present.
- Microsoft Learn — *Use Table-Valued Parameters (Database Engine)*
- Microsoft Learn — *CREATE TYPE (Transact-SQL)*