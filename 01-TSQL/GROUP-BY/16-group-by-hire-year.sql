-- =============================================
-- تمرین ۱۶: GROUP BY با YEAR
-- =============================================
-- هدف: تعداد استخدام‌ها در هر سال

SELECT 
    YEAR(HireDate) as HireYear,
    COUNT(*) as EmployeeCount
FROM Employees
GROUP BY YEAR(HireDate)
ORDER BY HireYear;