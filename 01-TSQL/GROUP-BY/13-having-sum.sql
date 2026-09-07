-- =============================================
-- تمرین ۱۳: HAVING با SUM
-- =============================================
-- هدف: بخش‌هایی که مجموع حقوق آنها بالای ۲۰۰۰۰ است

SELECT 
    Department,
    SUM(Salary) as TotalSalary
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 20000
ORDER BY TotalSalary DESC;