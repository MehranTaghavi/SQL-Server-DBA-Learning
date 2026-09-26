-- ================================================================
-- 📘 Exercise 19-1: Salary categorization with CASE WHEN
-- ================================================================
-- 
-- 🎯 Goal:
-- Categorize employees into 4 groups based on salary level
--
-- 📚 Key concepts:
-- 1. CASE WHEN with multiple conditions
-- 2. Bucketing numeric data into qualitative groups
-- 3. Using comparison operators inside CASE
--
-- 📋 Category rules:
-- 🌟 High salary:        Salary >= 8000
-- 📊 Medium salary:      6000 <= Salary < 8000
-- 📉 Low salary:         4000 <= Salary < 6000
-- ⚠️ Very low salary:    Salary < 4000
--
-- 🔍 How it works:
-- 1. The query reads all employees
-- 2. CASE WHEN checks the Salary value
-- 3. The first TRUE condition determines the returned value
-- 4. If no condition matches, ELSE runs
--
-- 📌 Important note on condition order:
-- Conditions must go from specific to general.
-- If "Salary >= 4000" were written first, it would also catch every higher salary!
-- ================================================================

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    -- 📊 Categorize salary with CASE WHEN
    CASE 
        WHEN Salary >= 8000 THEN 'High Salary 🌟'          -- top category
        WHEN Salary >= 6000 AND Salary < 8000 THEN 'Medium Salary 📊'  -- medium category
        WHEN Salary >= 4000 AND Salary < 6000 THEN 'Low Salary 📉'     -- low category
        ELSE 'Very Low Salary ⚠️'                          -- if below 4000
    END as SalaryCategory
FROM Employees
ORDER BY Salary DESC;

-- ================================================================
-- 📊 Expected output:
-- ┌───────────┬───────────┬────────────┬────────┬──────────────────┐
-- │ FirstName │ LastName  │ Department │ Salary │  SalaryCategory  │
-- ├───────────┼───────────┼────────────┼────────┼──────────────────┤
-- │ Reza      │ Karimi    │ Sales      │ 9100   │ High Salary 🌟   │
-- │ Ali       │ Ahmadi    │ IT         │ 8500   │ High Salary 🌟   │
-- │ Neda      │ Jafari    │ HR         │ 8300   │ High Salary 🌟   │
-- │ Zahra     │ Alavi     │ IT         │ 7800   │ Medium Salary 📊 │
-- │ Sara      │ Mohammadi │ IT         │ 7200   │ Medium Salary 📊 │
-- │ Hossein   │ Razavi    │ HR         │ 6200   │ Medium Salary 📊 │
-- │ Mina      │ Hasani    │ Sales      │ 5800   │ Low Salary 📉    │
-- │ Mohammad  │ Moradi    │ Sales      │ 5400   │ Low Salary 📉    │
-- └───────────┴───────────┴────────────┴────────┴──────────────────┘
--
-- 💡 Interpreting the results:
-- - 3 employees fall into High Salary (Reza, Ali, Neda)
-- - 3 employees fall into Medium Salary (Zahra, Sara, Hossein)
-- - 2 employees fall into Low Salary (Mina, Mohammad)
-- - No one falls into Very Low Salary
-- ================================================================
