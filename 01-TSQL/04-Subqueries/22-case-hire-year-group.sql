-- ================================================================
-- 📘 Exercise 19-4: Grouping by hire year with CASE WHEN
-- ================================================================
-- 
-- 🎯 Goal:
-- Categorize employees by hire year using CASE WHEN
--
-- 📚 Key concepts:
-- 1. Using the YEAR() function to extract the year from a date
-- 2. CASE WHEN combined with date functions
-- 3. Grouping data by time period
--
-- 📋 Hire years:
-- 🏛️ 2020: earliest hires
-- 📅 2021: second year
-- 🆕 2022: third year
-- 🌱 2023: newest hires
--
-- 🔍 How it works:
-- 1. YEAR(HireDate) extracts the hire year
-- 2. CASE WHEN compares that year against specific values
-- 3. Each employee is assigned the matching category
-- ================================================================

SELECT 
    FirstName,
    LastName,
    Department,
    HireDate,
    -- 📊 Categorize by hire year
    CASE 
        WHEN YEAR(HireDate) = 2020 THEN 'Hired in 2020 🏛️'
        WHEN YEAR(HireDate) = 2021 THEN 'Hired in 2021 📅'
        WHEN YEAR(HireDate) = 2022 THEN 'Hired in 2022 🆕'
        WHEN YEAR(HireDate) = 2023 THEN 'Hired in 2023 🌱'
        ELSE 'Other'  -- any other year
    END as HireYearGroup
FROM Employees
ORDER BY HireDate;

-- ================================================================
-- 📊 Expected output:
-- ┌───────────┬───────────┬────────────┬────────────┬─────────────────┐
-- │ FirstName │ LastName  │ Department │  HireDate  │  HireYearGroup  │
-- ├───────────┼───────────┼────────────┼────────────┼─────────────────┤
-- │ Reza      │ Karimi    │ Sales      │ 2020-06-10 │ Hired in 2020 🏛️│
-- │ Neda      │ Jafari    │ HR         │ 2020-12-01 │ Hired in 2020 🏛️│
-- │ Ali       │ Ahmadi    │ IT         │ 2021-01-15 │ Hired in 2021 📅│
-- │ Zahra     │ Alavi     │ IT         │ 2021-11-01 │ Hired in 2021 📅│
-- │ Sara      │ Mohammadi │ IT         │ 2022-03-20 │ Hired in 2022 🆕│
-- │ Hossein   │ Razavi    │ HR         │ 2022-08-12 │ Hired in 2022 🆕│
-- │ Mina      │ Hasani    │ Sales      │ 2023-01-05 │ Hired in 2023 🌱│
-- │ Mohammad  │ Moradi    │ Sales      │ 2023-04-18 │ Hired in 2023 🌱│
-- └───────────┴───────────┴────────────┴────────────┴─────────────────┘
--
-- 💡 Uses of this technique:
-- 1. Analyzing hiring trends across years
-- 2. Identifying peak-hiring periods
-- 3. Comparing department performance across years
-- ================================================================
