-- ================================================================
-- 📘 تمرین ۲۲: داشبورد عملکرد بخش‌ها
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- ایجاد یک داشبورد کامل از عملکرد هر بخش با استفاده از ترکیب
-- چندین تکنیک پیشرفته SQL
--
-- 📚 مفاهیم کلیدی ترکیب‌شده:
-- 1. CTE برای محاسبات چندمرحله‌ای
-- 2. Subquery در SELECT
-- 3. Subquery در WHERE
-- 4. CASE WHEN برای دسته‌بندی
-- 5. توابع تجمعی
-- 6. محاسبات آماری
--
-- 🔍 سوالات تجاری که این کوئری پاسخ می‌دهد:
-- 1. عملکرد کلی هر بخش چگونه است؟
-- 2. کدام بخش بهترین عملکرد را دارد؟
-- 3. چه نسبتی از کارمندان هر بخش بالاتر از میانگین شرکت هستند؟
-- ================================================================

WITH 
-- 📊 مرحله ۱: آمار پایه هر بخش
DepartmentStats AS (
    SELECT 
        Department,
        COUNT(*) as TotalEmployees,
        AVG(Salary) as AvgSalary,
        MAX(Salary) as MaxSalary,
        MIN(Salary) as MinSalary,
        SUM(Salary) as TotalSalary,
        STDEV(Salary) as SalaryStdDev
    FROM Employees
    GROUP BY Department
),
-- 📊 مرحله ۲: میانگین کل شرکت
CompanyAvg AS (
    SELECT AVG(Salary) as OverallAvg FROM Employees
),
-- 📊 مرحله ۳: کارمندانی که بالاتر از میانگین شرکت هستند
AboveAvgEmployees AS (
    SELECT 
        Department,
        COUNT(*) as AboveAvgCount
    FROM Employees
    WHERE Salary > (SELECT AVG(Salary) FROM Employees)
    GROUP BY Department
)
-- 📊 مرحله ۴: گزارش نهایی
SELECT 
    ds.Department,
    ds.TotalEmployees,
    ds.AvgSalary,
    ds.MaxSalary,
    ds.MinSalary,
    ds.TotalSalary,
    ROUND(ds.SalaryStdDev, 2) as SalaryStdDev,
    
    -- 📊 اختلاف با میانگین کل شرکت
    ROUND(ds.AvgSalary - (SELECT OverallAvg FROM CompanyAvg), 2) as DiffFromCompanyAvg,
    
    -- 📊 تعداد و درصد کارمندان بالاتر از میانگین
    ISNULL(aae.AboveAvgCount, 0) as AboveAvgCount,
    ROUND(ISNULL(aae.AboveAvgCount, 0) * 100.0 / ds.TotalEmployees, 2) as AboveAvgPercent,
    
    -- 📊 دامنه تغییرات حقوق
    ds.MaxSalary - ds.MinSalary as SalaryRange,
    
    -- 📊 ضریب تغییرات (CV) = انحراف معیار / میانگین
    ROUND(ds.SalaryStdDev / ds.AvgSalary, 3) as CoefficientOfVariation,
    
    -- 📊 رتبه‌بندی بخش بر اساس میانگین حقوق
    RANK() OVER (ORDER BY ds.AvgSalary DESC) as SalaryRank,
    
    -- 📊 ارزیابی عملکرد
    CASE 
        WHEN ds.AvgSalary > (SELECT OverallAvg * 1.1 FROM CompanyAvg) THEN 'عالی 🌟'
        WHEN ds.AvgSalary > (SELECT OverallAvg FROM CompanyAvg) THEN 'خوب ✅'
        WHEN ds.AvgSalary > (SELECT OverallAvg * 0.9 FROM CompanyAvg) THEN 'متوسط 📊'
        ELSE 'نیاز به بهبود ⚠️'
    END as PerformanceRating
    
FROM DepartmentStats ds
LEFT JOIN AboveAvgEmployees aae ON ds.Department = aae.Department
ORDER BY ds.AvgSalary DESC;

-- ================================================================
-- 📊 خروجی مورد انتظار:
-- ┌────────────┬───────────────┬───────────┬───────────┬───────────┬─────────────┬───────────────┬──────────────────────┬────────────────┬────────────────┬──────────────────────┬─────────────┬───────────┬────────────────────┬───────────────┬─────────────────────┐
-- │ Department │ TotalEmployees│ AvgSalary │ MaxSalary │ MinSalary │ TotalSalary │ SalaryStdDev  │ DiffFromCompanyAvg │ AboveAvgCount │ AboveAvgPercent│ SalaryRange         │ CoefVar     │ SalaryRank│ PerformanceRating  │
-- ├────────────┼───────────────┼───────────┼───────────┼───────────┼─────────────┼───────────────┼──────────────────────┼────────────────┼────────────────┼─────────────────────┼─────────────┼───────────┼─────────────────────┤
-- │ IT         │ 3             │ 7833.33   │ 8500      │ 7200      │ 23500       │ 665.80        │ 545.83              │ 2              │ 66.67          │ 1300                │ 0.085       │ 1         │ عالی 🌟             │
-- │ HR         │ 2             │ 7250.00   │ 8300      │ 6200      │ 14500       │ 1484.92       │ -37.50              │ 1              │ 50.00          │ 2100                │ 0.205       │ 2         │ متوسط 📊            │
-- │ Sales      │ 3             │ 6766.67   │ 9100      │ 5400      │ 20300       │ 1978.71       │ -520.83             │ 1              │ 33.33          │ 3700                │ 0.292       │ 3         │ نیاز به بهبود ⚠️   │
-- └────────────┴───────────────┴───────────┴───────────┴───────────┴─────────────┴───────────────┴──────────────────────┴────────────────┴────────────────┴─────────────────────┴─────────────┴───────────┴─────────────────────┘
--
-- 💡 تفسیر نتایج:
-- 🔹 IT: بهترین عملکرد با بالاترین میانگین حقوق و کمترین ضریب تغییرات
-- 🔹 HR: عملکرد متوسط با بیشترین پراکندگی حقوق
-- 🔹 Sales: پایین‌ترین عملکرد با بیشترین دامنه تغییرات حقوق
-- ================================================================
