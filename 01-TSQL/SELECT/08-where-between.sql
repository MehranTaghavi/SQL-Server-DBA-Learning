-- =============================================
-- تمرین ۸: WHERE با BETWEEN
-- =============================================
-- هدف: نمایش کارمندانی با حقوق بین ۶۰۰۰ تا ۸۰۰۰

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary BETWEEN 6000 AND 8000
ORDER BY Salary DESC;
