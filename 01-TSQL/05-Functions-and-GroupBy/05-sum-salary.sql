-- =============================================
-- تمرین ۵: SUM با GROUP BY
-- =============================================
-- هدف: مجموع حقوق هر بخش را محاسبه کنید

SELECT 
    Department,
    SUM(Salary) as TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;