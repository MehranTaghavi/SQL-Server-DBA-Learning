-- =============================================
-- تمرین ۲۰: TOP درصد
-- =============================================
-- هدف: نمایش ۲۰٪ کارمندانی که بیشترین حقوق را دارند

SELECT TOP 20 PERCENT
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary DESC;

-- خروجی: Reza (9100), Ali (8500)
