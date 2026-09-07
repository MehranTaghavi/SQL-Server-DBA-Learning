-- =============================================
-- تمرین ۱: Subquery ساده در WHERE
-- =============================================
-- هدف: پیدا کردن کارمند با بیشترین حقوق

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);
