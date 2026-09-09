-- =============================================
-- Window Functions - Practice Set 01
-- Repository: SQL-Server-DBA-Learning
-- Path: 01-TSQL/08-Window-Functions
-- =============================================

-- 1) Assign a sequential row number by salary (highest first)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumBySalary
FROM Employees;


-- 2) Rank employees by salary (gaps in rank when ties exist)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


-- 3) Dense rank employees by salary (no gaps in rank)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryDenseRank
FROM Employees;


-- 4) Show previous and next salary values in salary order
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    LAG(Salary) OVER (ORDER BY Salary DESC) AS PreviousSalary,
    LEAD(Salary) OVER (ORDER BY Salary DESC) AS NextSalary
FROM Employees;


-- 5) Running total of salary by hire date
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    HireDate,
    Salary,
    SUM(Salary) OVER (
        ORDER BY HireDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningSalaryTotal
FROM Employees;


-- 6) Department-level average and total salary using PARTITION BY
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees;


-- 7) Difference from department average salary
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees;


-- 8) Top 3 salaries in each department
WITH RankedByDepartment AS (
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Department,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS DeptSalaryRank
    FROM Employees
)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    DeptSalaryRank
FROM RankedByDepartment
WHERE DeptSalaryRank <= 3
ORDER BY Department, DeptSalaryRank, Salary DESC;
