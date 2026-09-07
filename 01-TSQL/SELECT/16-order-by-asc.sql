-- =============================================
-- تمرین ۱۶: ORDER BY ASC
-- =============================================
-- هدف: نمایش کارمندان بر اساس حقوق از کم به زیاد

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
ORDER BY Salary ASC;
