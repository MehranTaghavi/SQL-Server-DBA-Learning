-- =============================================
-- تمرین ۲: Subquery با IN
-- =============================================
-- هدف: کارمندانی که در بخش‌های با میانگین حقوق بالای ۷۰۰۰ هستند

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
ORDER BY Department, Salary DESC;
