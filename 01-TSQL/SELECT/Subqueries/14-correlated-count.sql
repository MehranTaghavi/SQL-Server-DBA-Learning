-- =============================================
-- تمرین ۱۴: Correlated Subquery با COUNT
-- =============================================
-- هدف: برای هر کارمند، تعداد کارمندانی که در همان بخش هستند
-- و حقوق بیشتری دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (
        SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.Department = e1.Department
        AND e2.Salary > e1.Salary
    ) as HigherInDept
FROM Employees e1
ORDER BY Department, Salary DESC;
