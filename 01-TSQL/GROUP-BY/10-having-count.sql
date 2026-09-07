-- =============================================
-- تمرین ۱۰: HAVING با COUNT
-- =============================================
-- هدف: بخش‌هایی که بیش از ۲ کارمند دارند

SELECT 
    Department,
    COUNT(*) as EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2
ORDER BY EmployeeCount DESC;