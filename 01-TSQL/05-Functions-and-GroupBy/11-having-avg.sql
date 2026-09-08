-- =============================================
-- تمرین ۱۱: HAVING با AVG
-- =============================================
-- هدف: بخش‌هایی که میانگین حقوق آنها بالای ۷۰۰۰ است

SELECT 
    Department,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 7000
ORDER BY AvgSalary DESC;