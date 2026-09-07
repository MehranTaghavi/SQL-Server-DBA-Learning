-- ================================================================
-- 📘 تمرین ۲۴: تحلیل شکاف حقوقی (Salary Gap Analysis)
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- شناسایی کارمندانی که بیشترین شکاف حقوقی را با میانگین بخش دارند
-- و تحلیل دلایل این شکاف
--
-- 📚 مفاهیم کلیدی ترکیب‌شده:
-- 1. CTE برای محاسبات چندمرحله‌ای
-- 2. Subquery در WHERE
-- 3. Window Functions (RANK, PERCENT_RANK)
-- 4. CASE WHEN برای دسته‌بندی
-- 5. ترکیب چندین جدول مجازی
--
-- 🔍 سوالات تجاری که این کوئری پاسخ می‌دهد:
-- 1. چه کسانی بیشترین شکاف حقوقی را دارند؟
-- 2. الگوی شکاف حقوقی در بخش‌ها چگونه است؟
-- 3. کدام بخش‌ها بیشترین نابرابری حقوقی را دارند؟
-- ================================================================

WITH 
-- 📊 مرحله ۱: آمار بخش‌ها
DeptStats AS (
    SELECT 
        Department,
        AVG(Salary) as AvgSalary,
        MAX(Salary) as MaxSalary,
        MIN(Salary) as MinSalary,
        COUNT(*) as DeptSize
    FROM Employees
    GROUP BY Department
),
-- 📊 مرحله ۲: تحلیل هر کارمند
EmployeeGap AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.Department,
        e.Salary,
        ds.AvgSalary,
        ds.MaxSalary,
        ds.MinSalary,
        -- 📊 شکاف‌های مختلف
        e.Salary - ds.AvgSalary as GapFromAvg,
        ds.MaxSalary - e.Salary as GapToMax,
        e.Salary - ds.MinSalary as GapFromMin,
        -- 📊 نسبت‌ها
        ROUND(e.Salary / ds.AvgSalary, 2) as SalaryRatio,
        -- 📊 رتبه‌بندی در بخش
        RANK() OVER (PARTITION BY e.Department ORDER BY e.Salary DESC) as DeptRank,
        -- 📊 درصد رتبه در بخش
        PERCENT_RANK() OVER (PARTITION BY e.Department ORDER BY e.Salary DESC) * 100 as PercentRank
    FROM Employees e
    INNER JOIN DeptStats ds ON e.Department = ds.Department
),
-- 📊 مرحله ۳: رتبه‌بندی شکاف‌ها
GapRanking AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY ABS(GapFromAvg) DESC) as GlobalGapRank,
        RANK() OVER (PARTITION BY Department ORDER BY ABS(GapFromAvg) DESC) as DeptGapRank
    FROM EmployeeGap
)
-- 📊 مرحله ۴: گزارش نهایی
SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    AvgSalary,
    ROUND(GapFromAvg, 2) as GapFromAvg,
    ROUND(GapToMax, 2) as GapToMax,
    ROUND(SalaryRatio, 2) as SalaryRatio,
    DeptRank as RankInDept,
    ROUND(PercentRank, 2) as PercentRank,
    -- 📊 وضعیت شکاف
    CASE 
        WHEN GapFromAvg > 0 THEN 'بالاتر از میانگین 📈'
        WHEN GapFromAvg < 0 THEN 'پایین‌تر از میانگین 📉'
        ELSE 'برابر با میانگین ⚖️'
    END as GapStatus,
    -- 📊 شدت شکاف
    CASE 
        WHEN ABS(GapFromAvg) > 1000 THEN 'شکاف شدید 🔴'
        WHEN ABS(GapFromAvg) > 500 THEN 'شکاف متوسط 🟡'
        ELSE 'شکاف کم 🟢'
    END as GapSeverity,
    -- 📊 توصیه
    CASE 
        WHEN GapFromAvg > 1000 THEN 'بررسی افزایش حقوق بقیه'
        WHEN GapFromAvg < -1000 THEN 'بررسی افزایش حقوق این کارمند'
        ELSE 'وضعیت متعادل'
    END as Recommendation
FROM GapRanking
WHERE DeptGapRank = 1 OR GlobalGapRank <= 3
ORDER BY ABS(GapFromAvg) DESC;

-- ================================================================
-- 📊 خروجی مورد انتظار:
-- ┌───────────┬───────────┬────────────┬────────┬────────────┬────────────┬───────────┬─────────────┬─────────────┬─────────────┬─────────────────────┬───────────────┬────────────────────────────┐
-- │ FirstName │ LastName  │ Department │ Salary │ AvgSalary  │ GapFromAvg │ GapToMax  │ SalaryRatio │ RankInDept │ PercentRank │ GapStatus           │ GapSeverity   │ Recommendation             │
-- ├───────────┼───────────┼────────────┼────────┼────────────┼────────────┼───────────┼─────────────┼─────────────┼─────────────┼─────────────────────┼───────────────┼────────────────────────────┤
-- │ Mohammad  │ Moradi    │ Sales      │ 5400   │ 6766.67    │ -1366.67   │ 3700      │ 0.80        │ 3           │ 100.00      │ پایین‌تر از میانگین 📉│ شکاف شدید 🔴 │ بررسی افزایش حقوق این کارمند│
-- │ Mina      │ Hasani    │ Sales      │ 5800   │ 6766.67    │ -966.67    │ 3300      │ 0.86        │ 2           │ 50.00       │ پایین‌تر از میانگین 📉│ شکاف شدید 🔴 │ بررسی افزایش حقوق این کارمند│
-- │ Reza      │ Karimi    │ Sales      │ 9100   │ 6766.67    │ 2333.33    │ 0         │ 1.34        │ 1           │ 0.00        │ بالاتر از میانگین 📈│ شکاف شدید 🔴 │ بررسی افزایش حقوق بقیه   │
-- └───────────┴───────────┴────────────┴────────┴────────────┴────────────┴───────────┴─────────────┴─────────────┴─────────────┴─────────────────────┴───────────────┴────────────────────────────┘
--
-- 💡 تفسیر نتایج:
-- 🔹 Reza: ۲۳۳۳.۳۳ بالاتر از میانگین (شکاف شدید مثبت)
-- 🔹 Mohammad: ۱۳۶۶.۶۷ پایین‌تر از میانگین (شکاف شدید منفی)
-- 🔹 Mina: ۹۶۶.۶۷ پایین‌تر از میانگین (شکاف شدید منفی)
-- 💡 نتیجه: بخش Sales بیشترین نابرابری حقوقی را دارد!
-- ================================================================
