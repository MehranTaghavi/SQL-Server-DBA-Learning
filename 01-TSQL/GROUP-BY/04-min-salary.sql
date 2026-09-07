-- =============================================
-- تمرین ۴: MIN با GROUP BY
-- =============================================
-- هدف: کمترین حقوق هر بخش را پیدا کنید

SELECT 
    Department,
    MIN(Salary) as MinSalary
FROM Employees
GROUP BY Department
ORDER BY MinSalary;