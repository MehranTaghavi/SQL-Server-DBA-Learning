-- =============================================
-- تمرین ۵: SELECT با ORDER BY
-- =============================================
-- هدف: نمایش کارمندان بر اساس حقوق از بیشتر به کمتر

SELECT 
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary DESC;
