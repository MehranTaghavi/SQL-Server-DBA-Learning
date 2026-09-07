-- =============================================
-- تمرین ۳: Subquery در SELECT
-- =============================================
-- هدف: نمایش حقوق به همراه بیشترین حقوق کل شرکت

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    (SELECT MAX(Salary) FROM Employees) as MaxSalary,
    (SELECT MAX(Salary) FROM Employees) - Salary as DiffFromMax
FROM Employees
ORDER BY Salary DESC;
