-- =============================================
-- تمرین ۱۹: TOP N
-- =============================================
-- هدف: نمایش ۳ کارمند با بیشترین حقوق

SELECT TOP 3 
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary DESC;

-- خروجی: Reza (9100), Ali (8500), Neda (8300)
