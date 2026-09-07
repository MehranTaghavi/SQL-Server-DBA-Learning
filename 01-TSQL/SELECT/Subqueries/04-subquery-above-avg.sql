-- =============================================
-- تمرین ۴: حقوق بالاتر از میانگین کل شرکت
-- =============================================
-- هدف: کارمندانی که حقوق آنها از میانگین کل بیشتر است

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;
