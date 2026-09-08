-- =============================================
-- تمرین ۷: EXISTS
-- =============================================
-- هدف: بخش‌هایی که حداقل یک کارمند با حقوق بالای ۸۰۰۰ دارند

SELECT 
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.Department = e1.Department
    AND e2.Salary > 8000
)
ORDER BY Department, Salary DESC;
