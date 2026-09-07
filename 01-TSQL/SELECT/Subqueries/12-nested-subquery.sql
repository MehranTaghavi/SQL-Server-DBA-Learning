-- =============================================
-- تمرین ۱۲: Subquery تو در تو
-- =============================================
-- هدف: کارمندانی که در بخش‌هایی با میانگین حقوق بالای ۷۰۰۰ هستند
-- و حقوق آنها از میانگین کل شرکت بیشتر است

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Department IN (
    SELECT Department
    FROM Employees
    GROUP BY Department
    HAVING AVG(Salary) > 7000
)
AND Salary > (
    SELECT AVG(Salary) FROM Employees
)
ORDER BY Department, Salary DESC;
