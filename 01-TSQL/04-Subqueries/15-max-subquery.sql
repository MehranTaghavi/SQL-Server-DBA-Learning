-- =============================================
-- تمرین ۱۵: پیدا کردن بیشترین حقوق هر بخش با Subquery
-- =============================================
-- هدف: نمایش کارمندانی که بیشترین حقوق را در بخش خود دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees e1
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees e2
    WHERE e2.Department = e1.Department
)
ORDER BY Department;
