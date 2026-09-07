-- =============================================
-- تمرین ۲۱: IS NULL
-- =============================================
-- هدف: پیدا کردن کارمندانی که Position ندارند
-- (در داده‌های ما همه Position دارند، اما برای تمرین)

SELECT 
    FirstName,
    LastName,
    Position
FROM Employees
WHERE Position IS NULL;

