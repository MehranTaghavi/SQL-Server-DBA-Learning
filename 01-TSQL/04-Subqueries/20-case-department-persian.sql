-- ================================================================
-- 📘 Exercise 19-2: Translating department names with CASE WHEN
-- ================================================================
-- 
-- 🎯 Goal:
-- Localize the company's department names into Persian using CASE WHEN.
-- This exercise demonstrates using CASE to translate/localize
-- data values for display -- the target language here is Persian,
-- but the same pattern works for localizing into any language.
--
-- 📚 Key concepts:
-- 1. Simple CASE WHEN (matching one column against several values)
-- 2. Translating and localizing data
-- 3. The shorter "simple CASE" form, for matching a single column
--
-- 🏗️ Simple CASE WHEN structure:
-- CASE ColumnName
--     WHEN value_1 THEN result_1
--     WHEN value_2 THEN result_2
--     ELSE default_result
-- END
--
-- 🔍 Difference from the earlier form:
-- Earlier form:  CASE WHEN condition THEN value
-- This form:     CASE column WHEN value THEN value
-- ================================================================

SELECT 
    FirstName,
    LastName,
    Department,
    -- 📊 Translate the department name into Persian
    CASE Department
        WHEN 'IT' THEN N'فناوری اطلاعات'
        WHEN 'Sales' THEN N'فروش'
        WHEN 'HR' THEN N'منابع انسانی'
        ELSE N'سایر'  -- any other department
    END as DepartmentName,
    Salary
FROM Employees
ORDER BY Department;

-- ================================================================
-- 📊 Expected output:
-- ┌───────────┬───────────┬────────────┬─────────────────────┬────────┐
-- │ FirstName │ LastName  │ Department │   DepartmentName    │ Salary │
-- ├───────────┼───────────┼────────────┼─────────────────────┼────────┤
-- │ Ali       │ Ahmadi    │ IT         │ فناوری اطلاعات      │ 8500   │
-- │ Sara      │ Mohammadi │ IT         │ فناوری اطلاعات      │ 7200   │
-- │ Zahra     │ Alavi     │ IT         │ فناوری اطلاعات      │ 7800   │
-- │ Reza      │ Karimi    │ Sales      │ فروش                │ 9100   │
-- │ Mina      │ Hasani    │ Sales      │ فروش                │ 5800   │
-- │ Mohammad  │ Moradi    │ Sales      │ فروش                │ 5400   │
-- │ Hossein   │ Razavi    │ HR         │ منابع انسانی        │ 6200   │
-- │ Neda      │ Jafari    │ HR         │ منابع انسانی        │ 8300   │
-- └───────────┴───────────┴────────────┴─────────────────────┴────────┘
--
-- 💡 Uses of this technique:
-- 1. Displaying data in different languages
-- 2. Converting department codes into readable names
-- 3. Standardizing naming in reports
-- ================================================================
