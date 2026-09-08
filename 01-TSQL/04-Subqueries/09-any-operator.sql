-- =============================================
-- تمرین ۹: عملگر ANY
-- =============================================
-- هدف: کارمندانی که حقوق آنها بیشتر از حداقل حقوق در Sales است

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > ANY (
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
)
ORDER BY Salary DESC;
