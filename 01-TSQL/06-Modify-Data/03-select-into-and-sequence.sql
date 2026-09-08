IF OBJECT_ID('tempdb..#ModifySnapshot') IS NOT NULL DROP TABLE #ModifySnapshot;
SELECT EmployeeID, FirstName, Salary INTO #ModifySnapshot
FROM dbo.Employees WHERE Salary > 8000;
CREATE SEQUENCE dbo.ModifyEmployeeSequence AS int START WITH 100 INCREMENT BY 1;
SELECT NEXT VALUE FOR dbo.ModifyEmployeeSequence AS GeneratedID, FirstName FROM #ModifySnapshot;
DROP SEQUENCE dbo.ModifyEmployeeSequence;
