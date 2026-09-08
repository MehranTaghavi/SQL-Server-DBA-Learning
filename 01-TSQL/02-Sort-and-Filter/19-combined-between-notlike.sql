-- =============================================
-- تمرین ۲۴: فیلتر ترکیبی با BETWEEN و NOT LIKE
-- =============================================
-- هدف: نمایش کارمندانی با شرایط زیر:
-- 1. حقوق بین ۵۵۰۰ تا ۸۵۰۰ باشد
-- 2. نام خانوادگی آن‌ها با حرف 'S' شروع نشود
-- 3. در بخش Sales نباشند
-- 4. مرتب‌سازی بر اساس بخش (صعودی) و سپس حقوق (نزولی)

SELECT 
    FirstName,
    LastName,
    Department,
    Position,
    Salary
FROM Employees
WHERE Salary BETWEEN 5500 AND 8500
AND LastName NOT LIKE 'S%'
AND Department <> 'Sales'
ORDER BY Department ASC, Salary DESC;
