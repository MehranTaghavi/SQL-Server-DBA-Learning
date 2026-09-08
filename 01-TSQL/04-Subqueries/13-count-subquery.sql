-- =============================================
-- تمرین ۱۳: COUNT با Subquery
-- =============================================
-- هدف: برای هر کارمند، تعداد کارمندانی که حقوق بیشتری دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (
        SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.Salary > e1.Salary
    ) as HigherSalaryCount
FROM Employees e1
ORDER BY Salary DESC;
