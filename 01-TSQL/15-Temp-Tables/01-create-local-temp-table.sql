/* ============================================================
   01-create-local-temp-table.sql
   ============================================================
   A TEMPORARY TABLE is a real table that lives in the tempdb
   database and disappears automatically when it is no longer
   needed. A name starting with a single # makes it LOCAL: only
   the session (connection) that created it can see it.

   You use it exactly like a normal table: INSERT, SELECT,
   UPDATE, DELETE all work. Fully self-contained -- no other
   table is needed.
   ============================================================ */

DROP TABLE IF EXISTS #EmpSmall;
GO

CREATE TABLE #EmpSmall (
    EmployeeID INT,
    FirstName  VARCHAR(50),
    Salary     DECIMAL(10,2)
);

INSERT INTO #EmpSmall (EmployeeID, FirstName, Salary) VALUES
(1, 'Ali',  90000),
(2, 'Sara', 75000),
(3, 'Reza', 85000);

SELECT EmployeeID, FirstName, Salary FROM #EmpSmall ORDER BY EmployeeID;

-- Modify it like any table:
UPDATE #EmpSmall SET Salary = Salary + 5000 WHERE EmployeeID = 2;
DELETE FROM #EmpSmall WHERE EmployeeID = 3;

SELECT EmployeeID, FirstName, Salary FROM #EmpSmall ORDER BY EmployeeID;

-- Good habit: drop it yourself when you are done.
DROP TABLE #EmpSmall;

-- ------------------------------------------------------------
-- Expected result:
--   First SELECT : 3 rows -- Ali 90000.00, Sara 75000.00, Reza 85000.00
--   Second SELECT: 2 rows -- Ali 90000.00, Sara 80000.00
--     (Sara got +5000; Reza was deleted)
-- ------------------------------------------------------------
