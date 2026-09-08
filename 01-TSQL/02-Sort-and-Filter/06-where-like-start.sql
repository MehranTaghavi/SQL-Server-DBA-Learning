-- =============================================
-- تمرین ۹: WHERE با LIKE (شروع با)
-- =============================================
-- هدف: نمایش کارمندانی که نام آنها با 'M' شروع می‌شود

SELECT 
    FirstName,
    LastName,
    Department
FROM Employees
WHERE FirstName LIKE 'M%';

-- خروجی: Mina, Mohammad
