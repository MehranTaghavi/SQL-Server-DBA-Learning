-- =============================================
-- تمرین ۱۱: Subquery در HAVING
-- =============================================
-- هدف: بخش‌هایی که میانگین حقوق آنها از میانگین کل بیشتر است

SELECT 
    Department,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > (SELECT AVG(Salary) FROM Employees)
ORDER BY AvgSalary DESC;
