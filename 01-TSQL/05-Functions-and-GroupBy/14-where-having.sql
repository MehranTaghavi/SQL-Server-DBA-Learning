-- =============================================
-- تمرین ۱۴: ترکیب WHERE و HAVING
-- =============================================
-- هدف: بخش‌هایی که میانگین حقوق کارمندانی که بعد از ۲۰۲۰ استخدام شده‌اند بالای ۷۰۰۰ است

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
WHERE YEAR(HireDate) > 2020
GROUP BY Department
HAVING AVG(Salary) > 7000
ORDER BY Department;