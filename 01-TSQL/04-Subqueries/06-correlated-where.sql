-- =============================================
-- تمرین ۶: Correlated Subquery در WHERE
-- =============================================
-- هدف: کارمندانی که حقوق آنها از میانگین بخش خود بیشتر است

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees e1
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees e2
    WHERE e2.Department = e1.Department
)
ORDER BY Department, Salary DESC;
