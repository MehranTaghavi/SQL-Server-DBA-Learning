-- =============================================
-- تمرین ۱۰: WHERE با LIKE (شامل)
-- =============================================
-- هدف: نمایش کارمندانی که نام آنها شامل 'a' است

SELECT 
    FirstName,
    LastName,
    Department
FROM Employees
WHERE FirstName LIKE '%a%';

-- خروجی: Sara, Zahra, Mohammad, Neda
