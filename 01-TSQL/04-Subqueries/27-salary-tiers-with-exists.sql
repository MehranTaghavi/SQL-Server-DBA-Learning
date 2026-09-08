-- ================================================================
-- 📘 تمرین ۲۱: تحلیل طبقات حقوقی با EXISTS
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- شناسایی بخش‌هایی که در هر طبقه حقوقی (High, Medium, Low) حداقل یک کارمند دارند
-- و نمایش ترکیب طبقاتی هر بخش
--
-- 📚 مفاهیم کلیدی ترکیب‌شده:
-- 1. EXISTS با چندین شرط
-- 2. CASE WHEN برای طبقه‌بندی
-- 3. CTE برای محاسبه آمار هر بخش
-- 4. COUNT با CASE برای گزارش‌گیری
-- 5. Subquery در SELECT
--
-- 🏗️ طبقه‌بندی حقوق:
-- 🌟 High:   Salary > 8000
-- 📊 Medium: 6000 <= Salary <= 8000
-- 📉 Low:    Salary < 6000
--
-- 🔍 سوالات تجاری که این کوئری پاسخ می‌دهد:
-- 1. کدام بخش‌ها در هر سه طبقه حقوقی کارمند دارند؟
-- 2. کدام بخش‌ها فقط در طبقات خاصی کارمند دارند؟
-- 3. ترکیب طبقاتی هر بخش چگونه است؟
-- ================================================================

WITH DepartmentTiers AS (
    -- 📊 مرحله ۱: محاسبه تعداد کارمندان در هر طبقه برای هر بخش
    SELECT 
        Department,
        COUNT(CASE WHEN Salary > 8000 THEN 1 END) as HighCount,
        COUNT(CASE WHEN Salary BETWEEN 6000 AND 8000 THEN 1 END) as MediumCount,
        COUNT(CASE WHEN Salary < 6000 THEN 1 END) as LowCount,
        COUNT(*) as TotalEmployees
    FROM Employees
    GROUP BY Department
)
SELECT 
    -- 📊 اطلاعات پایه
    dt.Department,
    dt.TotalEmployees,
    dt.HighCount,
    dt.MediumCount,
    dt.LowCount,
    
    -- 📊 درصد هر طبقه
    ROUND(dt.HighCount * 100.0 / dt.TotalEmployees, 2) as HighPercent,
    ROUND(dt.MediumCount * 100.0 / dt.TotalEmployees, 2) as MediumPercent,
    ROUND(dt.LowCount * 100.0 / dt.TotalEmployees, 2) as LowPercent,
    
    -- 📊 وضعیت وجود طبقات (با EXISTS)
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary > 8000)
        THEN '✅'
        ELSE '❌'
    END as HasHigh,
    
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary BETWEEN 6000 AND 8000)
        THEN '✅'
        ELSE '❌'
    END as HasMedium,
    
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary < 6000)
        THEN '✅'
        ELSE '❌'
    END as HasLow,
    
    -- 📊 دسته‌بندی ترکیبی بخش
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary > 8000)
         AND EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary BETWEEN 6000 AND 8000)
         AND EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary < 6000)
        THEN 'همه طبقات 🌈'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary > 8000)
         AND EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary BETWEEN 6000 AND 8000)
        THEN 'High + Medium 📈'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary BETWEEN 6000 AND 8000)
         AND EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary < 6000)
        THEN 'Medium + Low 📊'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary > 8000)
         AND EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary < 6000)
        THEN 'High + Low 🎯'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary > 8000)
        THEN 'فقط High 🌟'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary BETWEEN 6000 AND 8000)
        THEN 'فقط Medium 📊'
        
        WHEN EXISTS (SELECT 1 FROM Employees e WHERE e.Department = dt.Department AND e.Salary < 6000)
        THEN 'فقط Low 📉'
        
        ELSE 'بدون کارمند ⚠️'
    END as DepartmentTierProfile
    
FROM DepartmentTiers dt
ORDER BY 
    CASE 
        WHEN dt.HighCount > 0 AND dt.MediumCount > 0 AND dt.LowCount > 0 THEN 1
        WHEN dt.HighCount > 0 AND dt.MediumCount > 0 THEN 2
        WHEN dt.MediumCount > 0 AND dt.LowCount > 0 THEN 3
        WHEN dt.HighCount > 0 AND dt.LowCount > 0 THEN 4
        ELSE 5
    END,
    dt.TotalEmployees DESC;

-- ================================================================
-- 📊 خروجی مورد انتظار:
-- ┌────────────┬───────────────┬───────────┬─────────────┬──────────┬─────────────┬───────────────┬───────────┬──────────┬────────┬──────────────┬───────────────────────────┐
-- │ Department │ TotalEmployees│ HighCount │ MediumCount │ LowCount │ HighPercent │ MediumPercent │ LowPercent │ HasHigh │ HasMed │ HasLow  │   DepartmentTierProfile   │
-- ├────────────┼───────────────┼───────────┼─────────────┼──────────┼─────────────┼───────────────┼───────────┼──────────┼────────┼──────────┼───────────────────────────┤
-- │ IT         │ 3             │ 2         │ 1           │ 0        │ 66.67       │ 33.33         │ 0.00      │ ✅      │ ✅     │ ❌      │ High + Medium 📈         │
-- │ Sales      │ 3             │ 1         │ 0           │ 2        │ 33.33       │ 0.00          │ 66.67     │ ✅      │ ❌     │ ✅      │ High + Low 🎯            │
-- │ HR         │ 2             │ 1         │ 1           │ 0        │ 50.00       │ 50.00         │ 0.00      │ ✅      │ ✅     │ ❌      │ High + Medium 📈         │
-- └────────────┴───────────────┴───────────┴─────────────┴──────────┴─────────────┴───────────────┴───────────┴──────────┴────────┴──────────┴───────────────────────────┘
--
-- 💡 تفسیر نتایج:
-- 🔹 IT: ترکیب High + Medium (بدون کارمند Low) → ۶۶.۶۷٪ High
-- 🔹 Sales: ترکیب High + Low (بدون کارمند Medium) → ۶۶.۶۷٪ Low
-- 🔹 HR: ترکیب High + Medium (بدون کارمند Low) → ۵۰٪ High
-- ================================================================
