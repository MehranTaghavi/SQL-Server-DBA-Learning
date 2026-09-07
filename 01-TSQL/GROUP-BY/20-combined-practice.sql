-- =============================================
-- تمرین ۲۰: تمرین ترکیبی نهایی
-- =============================================
-- هدف: نمایش بخش‌هایی که:
-- 1. بیش از ۲ کارمند دارند
-- 2. میانگین حقوق بالای ۷۰۰۰ است
-- 3. بیشترین حقوق بالای ۸۰۰۰ است
-- 4. مجموع حقوق بالای ۲۰۰۰۰ است

SELECT 
    Department,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary,
    MAX(Salary) as MaxSalary,
    SUM(Salary) as TotalSalary
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2
    AND AVG(Salary) > 7000
    AND MAX(Salary) > 8000
    AND SUM(Salary) > 20000
ORDER BY AvgSalary DESC;