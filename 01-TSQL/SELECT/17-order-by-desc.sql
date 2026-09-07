-- =============================================
-- تمرین ۱۷: ORDER BY DESC
-- =============================================
-- هدف: نمایش کارمندان بر اساس تاریخ استخدام از جدید به قدیم

SELECT 
    FirstName,
    LastName,
    HireDate
FROM Employees
ORDER BY HireDate DESC;
