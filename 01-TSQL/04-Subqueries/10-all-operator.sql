-- =============================================
-- تمرین ۱۰: عملگر ALL
-- =============================================
-- هدف: کارمندانی که حقوق آنها بیشتر از تمام حقوق‌های Sales است

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > ALL (
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
)
ORDER BY Salary DESC;
