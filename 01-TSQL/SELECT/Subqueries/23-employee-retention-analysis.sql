-- ================================================================
-- 📘 تمرین ۲۳: تحلیل ریسک ترک کار (Employee Retention Analysis)
-- ================================================================
-- 
-- 🎯 هدف تمرین:
-- شناسایی کارمندانی که در معرض ریسک ترک کار هستند
-- بر اساس ترکیبی از عوامل: حقوق پایین‌تر از میانگین بخش و سابقه کم
--
-- 📚 مفاهیم کلیدی ترکیب‌شده:
-- 1. Correlated Subquery برای محاسبه میانگین بخش
-- 2. CASE WHEN برای ارزیابی ریسک
-- 3. CTE برای محاسبات چندمرحله‌ای
-- 4. ترکیب چندین شرط
-- 5. Subquery در SELECT
--
-- 🔍 سوالات تجاری که این کوئری پاسخ می‌دهد:
-- 1. کدام کارمندان در معرض ریسک ترک کار هستند؟
-- 2. چه عواملی در ریسک ترک کار نقش دارند؟
-- 3. کدام بخش‌ها بیشترین ریسک را دارند؟
-- ================================================================

WITH 
-- 📊 مرحله ۱: محاسبه میانگین بخش
DeptAvg AS (
    SELECT 
        Department,
        AVG(Salary) as AvgSalary,
        COUNT(*) as DeptSize
    FROM Employees
    GROUP BY Department
),
-- 📊 مرحله ۲: محاسبه ریسک هر کارمند
EmployeeRisk AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.Department,
        e.Salary,
        e.HireDate,
        da.AvgSalary as DeptAvg,
        da.DeptSize,
        -- 📊 اختلاف با میانگین بخش
        e.Salary - da.AvgSalary as SalaryDiff,
        -- 📊 سابقه کار (سال)
        DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsEmployed,
        -- 📊 امتیاز ریسک
        CASE 
            -- 🚨 ریسک بالا: حقوق پایین‌تر از میانگین و سابقه کم (کمتر از ۲ سال)
            WHEN e.Salary < da.AvgSalary AND DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 3
            -- ⚠️ ریسک متوسط: حقوق پایین‌تر از میانگین یا سابقه کم
            WHEN e.Salary < da.AvgSalary OR DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 2
            -- ✅ ریسک پایین
            ELSE 1
        END as RiskScore
    FROM Employees e
    INNER JOIN DeptAvg da ON e.Department = da.Department
)
-- 📊 مرحله ۳: گزارش نهایی
SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    DeptAvg,
    ROUND(SalaryDiff, 2) as SalaryDiff,
    YearsEmployed,
    -- 📊 وضعیت حقوق
    CASE 
        WHEN Salary > DeptAvg THEN 'بالاتر از میانگین ✅'
        WHEN Salary < DeptAvg THEN 'پایین‌تر از میانگین ❌'
        ELSE 'برابر با میانگین ⚖️'
    END as SalaryStatus,
    -- 📊 وضعیت سابقه
    CASE 
        WHEN YearsEmployed >= 3 THEN 'با سابقه 📅'
        WHEN YearsEmployed >= 1 THEN 'نسبتاً جدید 🆕'
        ELSE 'جدید 🌱'
    END as SeniorityStatus,
    -- 📊 سطح ریسک نهایی
    CASE RiskScore
        WHEN 3 THEN 'ریسک بالا 🚨'
        WHEN 2 THEN 'ریسک متوسط ⚠️'
        ELSE 'ریسک پایین ✅'
    END as RiskLevel,
    -- 📊 توصیه مدیریتی
    CASE RiskScore
        WHEN 3 THEN 'افزایش حقوق و توجه ویژه'
        WHEN 2 THEN 'بررسی وضعیت و برنامه‌ریزی'
        ELSE 'ادامه وضعیت فعلی'
    END as ManagementRecommendation
FROM EmployeeRisk
ORDER BY RiskScore DESC, SalaryDiff ASC;

-- ================================================================
-- 📊 خروجی مورد انتظار:
-- ┌───────────┬───────────┬────────────┬────────┬────────────┬────────────┬───────────────┬─────────────────────┬───────────────────┬──────────────┬────────────────────────────┐
-- │ FirstName │ LastName  │ Department │ Salary │ DeptAvg    │ SalaryDiff │ YearsEmployed │ SalaryStatus         │ SeniorityStatus   │ RiskLevel    │ ManagementRecommendation │
-- ├───────────┼───────────┼────────────┼────────┼────────────┼────────────┼───────────────┼─────────────────────┼───────────────────┼──────────────┼────────────────────────────┤
-- │ Sara      │ Mohammadi │ IT         │ 7200   │ 7833.33    │ -633.33    │ 2             │ پایین‌تر از میانگین ❌│ نسبتاً جدید 🆕   │ ریسک متوسط ⚠️│ بررسی وضعیت و برنامه‌ریزی │
-- │ Mina      │ Hasani    │ Sales      │ 5800   │ 6766.67    │ -966.67    │ 1             │ پایین‌تر از میانگین ❌│ جدید 🌱          │ ریسک بالا 🚨 │ افزایش حقوق و توجه ویژه  │
-- │ Mohammad  │ Moradi    │ Sales      │ 5400   │ 6766.67    │ -1366.67   │ 1             │ پایین‌تر از میانگین ❌│ جدید 🌱          │ ریسک بالا 🚨 │ افزایش حقوق و توجه ویژه  │
-- └───────────┴───────────┴────────────┴────────┴────────────┴────────────┴───────────────┴─────────────────────┴───────────────────┴──────────────┴────────────────────────────┘
--
-- 💡 تفسیر نتایج:
-- 🔹 Mina و Mohammad: ریسک بالا (حقوق پایین + سابقه کم) → نیاز به توجه فوری
-- 🔹 Sara: ریسک متوسط (حقوق پایین اما سابقه نسبتاً خوب)
-- ================================================================
