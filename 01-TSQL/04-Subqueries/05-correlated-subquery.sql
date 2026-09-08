-- =============================================
-- تمرین ۵: Correlated Subquery
-- =============================================
-- هدف: نمایش میانگین حقوق بخش برای هر کارمند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (SELECT AVG(Salary) 
     FROM Employees e2
     WHERE e2.Department = e1.Department) as DeptAvg
FROM Employees e1
ORDER BY Department, Salary DESC;
