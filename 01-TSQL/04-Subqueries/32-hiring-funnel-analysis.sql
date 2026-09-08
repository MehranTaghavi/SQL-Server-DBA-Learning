-- ================================================================
-- 📘 تمرین ۲۵: تحلیل قیف استخدام (Hiring Funnel Analysis)
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- تحلیل روند استخدام در طول زمان و شناسایی الگوهای استخدام
-- در بخش‌های مختلف
--
-- 📚 مفاهیم کلیدی ترکیب‌شده:
-- 1. CTE برای محاسبات چندمرحله‌ای
-- 2. Subquery در SELECT و WHERE
-- 3. Window Functions برای محاسبات تجمعی
-- 4. CASE WHEN برای دسته‌بندی زمانی
-- 5. ترکیب توابع تاریخ و تجمعی
--
-- 🔍 سوالات تجاری که این کوئری پاسخ می‌دهد:
-- 1. روند استخدام در طول سال‌های مختلف چگونه است؟
-- 2. کدام سال‌ها بیشترین استخدام را داشته‌اند؟
-- 3. الگوی استخدام در بخش‌ها چگونه است؟
-- ================================================================

WITH 
-- 📊 مرحله ۱: آمار استخدام سالانه
YearlyHires AS (
    SELECT 
        YEAR(HireDate) as HireYear,
        Department,
        COUNT(*) as HiresCount,
        AVG(Salary) as AvgHireSalary,
        MIN(Salary) as MinHireSalary,
        MAX(Salary) as MaxHireSalary
    FROM Employees
    GROUP BY YEAR(HireDate), Department
),
-- 📊 مرحله ۲: محاسبه درصد تغییرات سالانه
YearlyTrend AS (
    SELECT 
        HireYear,
        Department,
        HiresCount,
        AvgHireSalary,
        -- 📊 تعداد کل استخدام‌های هر سال
        SUM(HiresCount) OVER (PARTITION BY HireYear) as TotalHiresYear,
        -- 📊 درصد استخدام بخش در سال
        ROUND(HiresCount * 100.0 / SUM(HiresCount) OVER (PARTITION BY HireYear), 2) as DeptHirePercent,
        -- 📊 درصد استخدام بخش نسبت به کل استخدام‌های آن بخش
        ROUND(HiresCount * 100.0 / SUM(HiresCount) OVER (PARTITION BY Department), 2) as DeptTotalPercent
    FROM YearlyHires
),
-- 📊 مرحله ۳: رتبه‌بندی سال‌ها
HireRanking AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY Department ORDER BY HiresCount DESC) as BestYearRank,
        RANK() OVER (ORDER BY TotalHiresYear DESC) as GlobalHireRank
    FROM YearlyTrend
)
-- 📊 مرحله ۴: گزارش نهایی
SELECT 
    HireYear,
    Department,
    HiresCount,
    TotalHiresYear,
    DeptHirePercent,
    ROUND(AvgHireSalary, 2) as AvgHireSalary,
    ROUND(MinHireSalary, 2) as MinHireSalary,
    ROUND(MaxHireSalary, 2) as MaxHireSalary,
    -- 📊 وضعیت سال
    CASE BestYearRank
        WHEN 1 THEN 'بهترین سال 🌟'
        WHEN 2 THEN 'سال خوب ✅'
        ELSE 'سال معمولی 📊'
    END as YearStatus,
    -- 📊 دسته‌بندی میزان استخدام
    CASE 
        WHEN HiresCount >= 3 THEN 'استخدام بالا 🚀'
        WHEN HiresCount >= 2 THEN 'استخدام متوسط 📈'
        ELSE 'استخدام پایین 📉'
    END as HiringLevel,
    -- 📊 توصیه
    CASE 
        WHEN BestYearRank = 1 THEN 'بررسی عوامل موفقیت'
        WHEN HiresCount = 0 THEN 'بررسی علت عدم استخدام'
        ELSE 'ادامه روند فعلی'
    END as Recommendation
FROM HireRanking
ORDER BY HireYear DESC, Department;

-- ================================================================
-- 📊 خروجی مورد انتظار:
-- ┌──────────┬────────────┬────────────┬─────────────────┬─────────────────┬───────────────┬───────────────┬───────────────┬────────────────┬───────────────────┬────────────────────────────┐
-- │ HireYear │ Department │ HiresCount │ TotalHiresYear │ DeptHirePercent │ AvgHireSalary │ MinHireSalary │ MaxHireSalary │ YearStatus     │ HiringLevel     │ Recommendation            │
-- ├──────────┼────────────┼────────────┼─────────────────┼─────────────────┼───────────────┼───────────────┼───────────────┼────────────────┼───────────────────┼────────────────────────────┤
-- │ 2023     │ Sales      │ 2          │ 2               │ 100.00          │ 5600.00       │ 5400.00       │ 5800.00       │ بهترین سال 🌟 │ استخدام متوسط 📈│ بررسی عوامل موفقیت        │
-- │ 2022     │ IT         │ 1          │ 2               │ 50.00           │ 7200.00       │ 7200.00       │ 7200.00       │ سال معمولی 📊 │ استخدام پایین 📉│ ادامه روند فعلی            │
-- │ 2022     │ HR         │ 1          │ 2               │ 50.00           │ 6200.00       │ 6200.00       │ 6200.00       │ سال معمولی 📊 │ استخدام پایین 📉│ ادامه روند فعلی            │
-- │ 2021     │ IT         │ 2          │ 2               │ 100.00          │ 8150.00       │ 7800.00       │ 8500.00       │ بهترین سال 🌟 │ استخدام متوسط 📈│ بررسی عوامل موفقیت        │
-- │ 2020     │ HR         │ 1          │ 2               │ 50.00           │ 8300.00       │ 8300.00       │ 8300.00       │ سال معمولی 📊 │ استخدام پایین 📉│ ادامه روند فعلی            │
-- │ 2020     │ Sales      │ 1          │ 2               │ 50.00           │ 9100.00       │ 9100.00       │ 9100.00       │ سال معمولی 📊 │ استخدام پایین 📉│ ادامه روند فعلی            │
-- └──────────┴────────────┴────────────┴─────────────────┴─────────────────┴───────────────┴───────────────┴───────────────┴────────────────┴───────────────────┴────────────────────────────┘
--
-- 💡 تفسیر نتایج:
-- 🔹 ۲۰۲۳: فقط در Sales استخدام داشته (۲ نفر با حقوق متوسط)
-- 🔹 ۲۰۲۱: بهترین سال برای IT (۲ نفر با حقوق بالا)
-- 🔹 ۲۰۲۰: استخدام در HR و Sales (هر کدام ۱ نفر)
-- 💡 نتیجه: الگوی استخدام در بخش‌ها متفاوت است و نیاز به تحلیل بیشتر دارد
-- ================================================================
