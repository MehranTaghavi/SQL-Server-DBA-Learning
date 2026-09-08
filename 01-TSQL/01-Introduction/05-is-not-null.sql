-- =============================================
-- تمرین ۲۲: IS NOT NULL
-- =============================================
-- هدف: نمایش کارمندانی که Position دارند
-- (همه کارمندان Position دارند)

SELECT 
    FirstName,
    LastName,
    Position
FROM Employees
WHERE Position IS NOT NULL
ORDER BY Position;
