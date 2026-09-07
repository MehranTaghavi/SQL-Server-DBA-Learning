-- =============================================
-- تمرین ۱۴: WHERE با AND
-- =============================================
-- هدف: نمایش کارمندانی که در بخش IT هستند و حقوق بالای ۷۵۰۰ دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Department = 'IT' 
AND Salary > 7500
ORDER BY Salary DESC;

-- خروجی: Ali (8500), Zahra (7800)
