-- =============================================
-- تمرین ۱۸: EXISTS با شرط پیچیده
-- =============================================
-- هدف: بخش‌هایی که میانگین حقوق آنها بالای ۷۰۰۰ است
-- و حداقل یک کارمند با حقوق بالای ۸۰۰۰ دارند

SELECT DISTINCT
    e1.Department
FROM Employees e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.Department = e1.Department
    AND e2.Salary > 8000
)
AND EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.Department = e1.Department
    GROUP BY e2.Department
    HAVING AVG(e2.Salary) > 7000
)
ORDER BY Department;
