-- =============================================
-- تمرین ۲۰: چند Correlated Subquery
-- =============================================
-- هدف: نمایش آمارهای مختلف برای هر کارمند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (SELECT AVG(Salary) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptAvg,
    (SELECT COUNT(*) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptCount,
    (SELECT MAX(Salary) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptMax,
    (SELECT COUNT(*) FROM Employees e2 WHERE e2.Department = e1.Department AND e2.Salary > e1.Salary) as HigherInDept
FROM Employees e1
ORDER BY Department, Salary DESC;
