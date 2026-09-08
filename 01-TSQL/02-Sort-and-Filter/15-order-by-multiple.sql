-- =============================================
-- تمرین ۱۸: ORDER BY چند ستون
-- =============================================
-- هدف: نمایش کارمندان بر اساس بخش و سپس حقوق از بیشتر به کمتر

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
ORDER BY Department ASC, Salary DESC;
