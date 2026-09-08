-- =============================================
-- تمرین ۱۲: WHERE با IN
-- =============================================
-- هدف: نمایش کارمندانی که در بخش‌های IT یا HR هستند

SELECT 
    FirstName,
    LastName,
    Department
FROM Employees
WHERE Department IN ('IT', 'HR')
ORDER BY Department;
