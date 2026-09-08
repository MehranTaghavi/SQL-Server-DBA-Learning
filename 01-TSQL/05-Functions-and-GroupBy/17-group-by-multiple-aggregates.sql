-- =============================================
-- تمرین ۱۷: چند تابع تجمعی با HAVING
-- =============================================
-- هدف: نمایش بخش‌هایی که میانگین حقوق بالای ۷۰۰۰ دارند و تعداد کارمندان آنها بیشتر از ۲ است

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary,
    MAX(Salary) as MaxSalary,
    MIN(Salary) as MinSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 7000 AND COUNT(*) > 2
ORDER BY AvgSalary DESC;