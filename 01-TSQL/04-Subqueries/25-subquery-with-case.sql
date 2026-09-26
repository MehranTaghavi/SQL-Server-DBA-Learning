-- ================================================================
-- 📘 Exercise 19: Subquery with CASE WHEN
-- ================================================================
-- 
-- 🎯 Goal:
-- Show each employee's salary status relative to their own department's
-- average salary, using CASE WHEN and a correlated subquery
--
-- 📚 Key concepts:
-- 1. Correlated Subquery: a subquery that depends on the outer row
-- 2. CASE WHEN: conditional logic in SQL, similar to IF-ELSE
-- 3. Comparing a value against a group average
--
-- 🏗️ CASE WHEN structure:
-- CASE 
--     WHEN first_condition THEN first_value
--     WHEN second_condition THEN second_value
--     ELSE default_value
-- END as column_name
--
-- 📌 Important CASE WHEN notes:
-- 1️⃣ Condition order matters (specific to general)
-- 2️⃣ ELSE is optional but recommended
-- 3️⃣ It can be combined with aggregate functions
-- 4️⃣ It can be used in ORDER BY and GROUP BY
--
-- 🔍 How the query works:
-- 1. The outer query reads and evaluates each employee once
-- 2. For each employee, the subquery computes their department's average salary
-- 3. CASE WHEN compares the employee's salary against that department average
-- 4. The result shows one of three states: above, below, or equal
-- ================================================================

SELECT 
    FirstName,
    LastName,
    Department,
    Salary,
    -- 📊 Subquery: compute the current row's department average salary
    (SELECT AVG(Salary) 
     FROM Employees e2 
     WHERE e2.Department = e1.Department) as DeptAvg,
    -- 📊 CASE WHEN: determine salary status relative to the department average
    CASE 
        WHEN Salary > (SELECT AVG(Salary) 
                       FROM Employees e2 
                       WHERE e2.Department = e1.Department)
        THEN 'Above Average ✅'
        WHEN Salary < (SELECT AVG(Salary) 
                       FROM Employees e2 
                       WHERE e2.Department = e1.Department)
        THEN 'Below Average ❌'
        ELSE 'Equal to Average ⚖️'  -- if salary exactly equals the average
    END as Status
FROM Employees e1
ORDER BY Department, Salary DESC;

-- ================================================================
-- 📊 Expected output:
-- ┌───────────┬───────────┬────────────┬────────┬─────────────┬──────────────────┐
-- │ FirstName │ LastName  │ Department │ Salary │  DeptAvg    │      Status      │
-- ├───────────┼───────────┼────────────┼────────┼─────────────┼──────────────────┤
-- │ Ali       │ Ahmadi    │ IT         │ 8500   │  7833.33    │ Above Average ✅ │
-- │ Zahra     │ Alavi     │ IT         │ 7800   │  7833.33    │ Below Average ❌ │
-- │ Sara      │ Mohammadi │ IT         │ 7200   │  7833.33    │ Below Average ❌ │
-- │ Reza      │ Karimi    │ Sales      │ 9100   │  6766.67    │ Above Average ✅ │
-- │ Mina      │ Hasani    │ Sales      │ 5800   │  6766.67    │ Below Average ❌ │
-- │ Mohammad  │ Moradi    │ Sales      │ 5400   │  6766.67    │ Below Average ❌ │
-- │ Neda      │ Jafari    │ HR         │ 8300   │  7250.00    │ Above Average ✅ │
-- │ Hossein   │ Razavi    │ HR         │ 6200   │  7250.00    │ Below Average ❌ │
-- └───────────┴───────────┴────────────┴────────┴─────────────┴──────────────────┘
--
-- 💡 Interpreting the results:
-- - In IT: only Ali is above the department average
-- - In Sales: only Reza is above the department average
-- - In HR: only Neda is above the department average
-- ================================================================