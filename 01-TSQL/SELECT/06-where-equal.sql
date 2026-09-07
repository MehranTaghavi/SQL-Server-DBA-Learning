-- =============================================
-- تمرین ۶: WHERE با عملگر =
-- =============================================
-- هدف: نمایش کارمندان بخش IT

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Department = 'IT';
