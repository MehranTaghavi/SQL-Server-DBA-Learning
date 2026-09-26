-- ================================================================
-- 📘 Exercise 19-5: Combining CASE WHEN with aggregate functions
-- ================================================================
-- 
-- 🎯 Goal:
-- Report the number of employees in each salary tier, per department,
-- using COUNT combined with CASE WHEN
--
-- 📚 Key concepts:
-- 1. COUNT(CASE WHEN ... THEN 1 END) for conditional counting
-- 2. Calculating a percentage using COUNT and ROUND
-- 3. Analytical reporting with CASE WHEN


-- 1️⃣ COUNT rule: COUNT only counts non-NULL values
-- 
-- 2️⃣ How it works:
--    - When the condition is TRUE  → returns 1 (non-NULL) → COUNT counts it ✅
--    - When the condition is FALSE → returns NULL          → COUNT skips it ❌
-- 
-- 3️⃣ Mathematical equivalent:
--    COUNT(CASE WHEN condition THEN 1 END) = number of rows where the condition is TRUE
-- 
-- 4️⃣ Why `1` and not `0` or something else?
--    - `1` is a lightweight constant
--    - any non-NULL value would work (e.g. 5, 100, or even 'YES')
--    - but `1` is the most readable and conventional choice
-- 
-- 5️⃣ What if we used `0` instead?
--    - `0` is also non-NULL, so it would still work
--    - but `1` is more conventional since it symbolizes "a count of one"
--
-- 📌 Note: this technique is called "Conditional Counting"
--
-- 📋 Salary tiers:
-- High salary:    Salary > 8000
-- Medium salary:  6000 <= Salary <= 8000
-- Low salary:     Salary < 6000
--
-- 🔍 How it works:
-- 1. COUNT(CASE WHEN Salary > 8000 THEN 1 END) counts only employees who satisfy the condition
-- 2. COUNT(*) computes the department's total employee count
-- 3. The percentage is computed as (conditional count / total count) * 100
-- ================================================================

SELECT 
    Department,
    -- 📊 Total employees in the department
    COUNT(*) as TotalEmployees,
    -- 📊 Employees earning above 8000
    COUNT(CASE WHEN Salary > 8000 THEN 1 END) as HighSalary,
    -- 📊 Employees earning between 6000 and 8000
    COUNT(CASE WHEN Salary BETWEEN 6000 AND 8000 THEN 1 END) as MediumSalary,
    -- 📊 Employees earning below 6000
    COUNT(CASE WHEN Salary < 6000 THEN 1 END) as LowSalary,
    -- 📊 Percentage of employees in the high-salary tier
    ROUND(COUNT(CASE WHEN Salary > 8000 THEN 1 END) * 100.0 / COUNT(*), 2) as HighPercent,
    -- 📊 Percentage of employees in the medium-salary tier
    ROUND(COUNT(CASE WHEN Salary BETWEEN 6000 AND 8000 THEN 1 END) * 100.0 / COUNT(*), 2) as MediumPercent,
    -- 📊 Percentage of employees in the low-salary tier
    ROUND(COUNT(CASE WHEN Salary < 6000 THEN 1 END) * 100.0 / COUNT(*), 2) as LowPercent
FROM Employees
GROUP BY Department
ORDER BY Department;

-- ================================================================
-- 📊 Expected output:
-- ┌────────────┬───────────────┬────────────┬─────────────┬───────────┬─────────────┬───────────────┬────────────┐
-- │ Department │ TotalEmployees│ HighSalary │ MediumSalary│ LowSalary │ HighPercent │ MediumPercent │ LowPercent │
-- ├────────────┼───────────────┼────────────┼─────────────┼───────────┼─────────────┼───────────────┼────────────┤
-- │ HR         │ 2             │ 1          │ 1           │ 0         │ 50.00       │ 50.00         │ 0.00       │
-- │ IT         │ 3             │ 2          │ 1           │ 0         │ 66.67       │ 33.33         │ 0.00       │
-- │ Sales      │ 3             │ 1          │ 0           │ 2         │ 33.33       │ 0.00          │ 66.67      │
-- └────────────┴───────────────┴────────────┴─────────────┴───────────┴─────────────┴───────────────┴────────────┘
--
-- 💡 Interpreting the results:
-- 🔹 IT department: 66.67% are in the high-salary tier (2 of 3 employees)
-- 🔹 HR department: 50% are in the high-salary tier (1 of 2 employees)
-- 🔹 Sales department: 66.67% are in the low-salary tier (2 of 3 employees)
--
-- 💡 Real-world uses:
-- 1. Management reports and dashboards
-- 2. Analyzing salary distribution across the organization
-- 3. Identifying high-performing departments
-- ================================================================