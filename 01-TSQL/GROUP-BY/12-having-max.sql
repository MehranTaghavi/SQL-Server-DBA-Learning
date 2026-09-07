-- =============================================
-- تمرین ۱۲: HAVING با MAX
-- =============================================
-- هدف: بخش‌هایی که بیشترین حقوق آنها بالای ۸۰۰۰ است

SELECT 
    Department,
    MAX(Salary) as MaxSalary,
    MIN(Salary) as MinSalary
FROM Employees
GROUP BY Department
HAVING MAX(Salary) > 8000
ORDER BY Department;