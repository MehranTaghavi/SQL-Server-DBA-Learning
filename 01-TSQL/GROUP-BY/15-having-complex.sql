-- =============================================
-- تمرین ۱۵: HAVING با چند شرط
-- =============================================
-- هدف: بخش‌هایی که بیش از ۲ کارمند دارند و میانگین حقوق آنها بالای ۷۰۰۰ است

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2 AND AVG(Salary) > 7000
ORDER BY Department;