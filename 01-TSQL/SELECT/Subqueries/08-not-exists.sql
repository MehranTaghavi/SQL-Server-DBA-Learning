-- =============================================
-- تمرین ۸: NOT EXISTS
-- =============================================
-- هدف: بخش‌هایی که هیچ کارمند با حقوق بالای ۸۵۰۰ ندارند

SELECT DISTINCT
    Department
FROM Employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.Department = e1.Department
    AND e2.Salary > 8500
)
ORDER BY Department;
