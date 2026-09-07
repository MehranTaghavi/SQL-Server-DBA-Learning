-- =============================================
-- تمرین ۷: WHERE با عملگر >
-- =============================================
-- هدف: نمایش کارمندانی با حقوق بیشتر از ۷۰۰۰

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > 7000
ORDER BY Salary DESC;
