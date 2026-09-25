-- ================================================================
-- 📘 Exercise 19-3: Calculating bonuses with CASE WHEN
-- ================================================================
-- 
-- 🎯 Goal:
-- Calculate each employee's annual bonus according to company rules
--
-- 📚 Key concepts:
-- 1. CASE WHEN combined with arithmetic
-- 2. A bonus rate driven by salary tier
-- 3. Showing the bonus percentage alongside the amount
--
-- 📋 Company bonus rules:
-- 🌟 High salary (≥ 8000):     20% bonus
-- 📊 Medium salary (6000-8000): 10% bonus
-- 📉 Low salary (< 6000):       5% bonus
--
-- 🧮 Formula:
-- Bonus = Salary * BonusRate
--
-- 🔍 How it works:
-- 1. CASE WHEN determines the salary tier
-- 2. The matching bonus rate is selected
-- 3. The bonus amount is calculated by multiplying salary by the rate
-- 4. The bonus percentage is also shown separately
-- ================================================================

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    -- 📊 Calculate the bonus amount
    CASE 
        WHEN Salary > 8000 THEN Salary * 0.20    -- 20% bonus
        WHEN Salary BETWEEN 6000 AND 8000 THEN Salary * 0.10  -- 10% bonus
        ELSE Salary * 0.05                       -- 5% bonus (below 6000)
    END as Bonus,
    -- 📊 Show the bonus percentage
    CASE 
        WHEN Salary > 8000 THEN '20%'
        WHEN Salary BETWEEN 6000 AND 8000 THEN '10%'
        ELSE '5%'
    END as BonusRate
FROM Employees
ORDER BY Salary DESC;

-- ================================================================
-- 📊 Expected output:
-- ┌───────────┬───────────┬────────────┬────────┬─────────┬───────────┐
-- │ FirstName │ LastName  │ Department │ Salary │  Bonus  │ BonusRate │
-- ├───────────┼───────────┼────────────┼────────┼─────────┼───────────┤
-- │ Reza      │ Karimi    │ Sales      │ 9100   │ 1820.00 │ 20%       │
-- │ Ali       │ Ahmadi    │ IT         │ 8500   │ 1700.00 │ 20%       │
-- │ Neda      │ Jafari    │ HR         │ 8300   │ 1660.00 │ 20%       │
-- │ Zahra     │ Alavi     │ IT         │ 7800   │ 780.00  │ 10%       │
-- │ Sara      │ Mohammadi │ IT         │ 7200   │ 720.00  │ 10%       │
-- │ Hossein   │ Razavi    │ HR         │ 6200   │ 620.00  │ 10%       │
-- │ Mina      │ Hasani    │ Sales      │ 5800   │ 290.00  │ 5%        │
-- │ Mohammad  │ Moradi    │ Sales      │ 5400   │ 270.00  │ 5%        │
-- └───────────┴───────────┴────────────┴────────┴─────────┴───────────┘
--
-- 💡 Learning notes:
-- 1. CASE WHEN can include arithmetic expressions
-- 2. CASE WHEN can be used multiple times in the same query
-- 3. Naming computed columns separately improves readability
-- ================================================================
