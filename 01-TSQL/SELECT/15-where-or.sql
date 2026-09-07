-- =============================================
-- تمرین ۱۵: WHERE با OR
-- =============================================
-- هدف: نمایش کارمندانی که در بخش Sales هستند یا حقوق بالای ۸۰۰۰ دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Department = 'Sales' 
OR Salary > 8000
ORDER BY Department, Salary DESC;
