-- =============================================
-- تمرین ۱۱: WHERE با LIKE (پایان با)
-- =============================================
-- هدف: نمایش کارمندانی که نام آنها با 'i' تمام می‌شود

SELECT 
    FirstName,
    LastName,
    Department
FROM Employees
WHERE FirstName LIKE '%i';

-- خروجی: Ali, Neda
