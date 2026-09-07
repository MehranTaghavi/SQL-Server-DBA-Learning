-- =============================================
-- تمرین ۲۳: تمرین ترکیبی
-- =============================================
-- هدف: نمایش کارمندان با شرایط زیر:
-- 1. در بخش IT یا HR باشند
-- 2. حقوق بالای ۷۰۰۰ داشته باشند
-- 3. نام آنها با 'A' یا 'N' شروع شود
-- 4. مرتب‌سازی بر اساس حقوق از بیشتر به کمتر

SELECT 
    FirstName,
    LastName,
    Department,
    Position,
    Salary,
    HireDate
FROM Employees
WHERE Department IN ('IT', 'HR')
AND Salary > 7000
AND (FirstName LIKE 'A%' OR FirstName LIKE 'N%')
ORDER BY Salary DESC;
