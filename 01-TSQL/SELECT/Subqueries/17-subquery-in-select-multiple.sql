-- =============================================
-- تمرین ۱۷: چند Subquery در SELECT
-- =============================================
-- هدف: نمایش آمار کامل برای هر کارمند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (SELECT AVG(Salary) FROM Employees) as CompanyAvg,
    (SELECT AVG(Salary) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptAvg,
    (SELECT MAX(Salary) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptMax,
    (SELECT COUNT(*) FROM Employees e2 WHERE e2.Department = e1.Department) as DeptCount
FROM Employees e1
ORDER BY Department, Salary DESC;
