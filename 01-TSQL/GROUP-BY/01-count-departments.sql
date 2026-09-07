-- =============================================
-- تمرین ۱: COUNT با GROUP BY
-- =============================================
-- هدف: تعداد کارمندان هر بخش را محاسبه کنید

SELECT 
    Department,
    COUNT(*) as EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY EmployeeCount DESC;