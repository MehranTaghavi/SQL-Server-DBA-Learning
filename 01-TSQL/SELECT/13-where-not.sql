-- =============================================
-- تمرین ۱۳: WHERE با NOT
-- =============================================
-- هدف: نمایش کارمندانی که در بخش Sales نیستند

SELECT 
    FirstName,
    LastName,
    Department
FROM Employees
WHERE NOT Department = 'Sales'
ORDER BY Department;
