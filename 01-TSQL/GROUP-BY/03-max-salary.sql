-- =============================================
-- تمرین ۳: MAX با GROUP BY
-- =============================================
-- هدف: بیشترین حقوق هر بخش را پیدا کنید

SELECT 
    Department,
    MAX(Salary) as MaxSalary
FROM Employees
GROUP BY Department
ORDER BY MaxSalary DESC;