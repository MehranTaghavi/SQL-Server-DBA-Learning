-- =============================================
-- تمرین ۹: WHERE با GROUP BY
-- =============================================
-- هدف: میانگین حقوق کارمندانی که بعد از ۲۰۲۱ استخدام شده‌اند در هر بخش

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
WHERE YEAR(HireDate) > 2021
GROUP BY Department
ORDER BY Department;