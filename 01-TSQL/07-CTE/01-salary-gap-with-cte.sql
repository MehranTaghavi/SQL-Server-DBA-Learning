-- ================================================================
-- 📘 تمرین ۲۱-۱: تحلیل شکاف حقوقی با CTE
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- شناسایی کارمندانی که حقوق آنها بیش از ۱۰٪ پایین‌تر از 
-- میانگین حقوق بخش خودشان است
--
-- 📚 مفاهیم کلیدی:
-- 1. CTE برای محاسبه میانگین حقوق هر بخش
-- 2. Subquery در WHERE
-- 3. محاسبه درصد اختلاف
--
-- 🎯 خروجی مورد انتظار:
-- کارمندانی که DiffPercent < -10 دارند
-- ================================================================

WITH DeptAvg AS (
    SELECT 
        Department,
        AVG(Salary) as AvgSalary
    FROM Employees
    GROUP BY Department
)
SELECT 
    e.FirstName,
    e.LastName,
    e.Department,
    e.Salary,
    ROUND(d.AvgSalary, 2) as DeptAvg,
    ROUND(((e.Salary - d.AvgSalary) / d.AvgSalary) * 100, 2) as DiffPercent,
    CASE 
        WHEN ((e.Salary - d.AvgSalary) / d.AvgSalary) * 100 < -10 
        THEN 'نیاز به بررسی ⚠️'
        ELSE 'وضعیت عادی ✅'
    END as Status
FROM Employees e
INNER JOIN DeptAvg d ON e.Department = d.Department
WHERE ((e.Salary - d.AvgSalary) / d.AvgSalary) * 100 < -10
ORDER BY DiffPercent ASC;
