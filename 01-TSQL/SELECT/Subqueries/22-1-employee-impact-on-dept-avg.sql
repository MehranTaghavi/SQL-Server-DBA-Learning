-- ================================================================
-- 📘 تمرین ۲۲-۱: تأثیر هر کارمند بر میانگین حقوق بخش
-- ================================================================
--
-- 🎯 هدف تمرین:
-- مشخص کردن کارمندانی که اگر از بخش خود حذف شوند،
-- بیشترین تغییر را در میانگین حقوق آن بخش ایجاد می‌کنند.
--
-- 📚 مفاهیم:
-- 1. CTE برای محاسبه میانگین بخش با و بدون هر کارمند
-- 2. Subquery در SELECT
-- 3. محاسبه اختلاف میانگین
-- 4. CASE WHEN برای دسته‌بندی تأثیر
--
-- 🔍 سوال تجاری:
-- کدام کارمندان بیشترین تأثیر را بر میانگین حقوق بخش خود دارند؟
-- ================================================================

WITH DeptAvg AS (
    SELECT 
        Department,
        AVG(Salary) AS OverallAvg
    FROM Employees
    GROUP BY Department
)
SELECT 
    e.FirstName,
    e.LastName,
    e.Department,
    e.Salary,
    ROUND(d.OverallAvg, 2) AS DeptAvg,
    ROUND((SELECT AVG(Salary) 
           FROM Employees e2 
           WHERE e2.Department = e.Department 
           AND e2.EmployeeID != e.EmployeeID), 2) AS AvgWithoutMe,
    ROUND(d.OverallAvg - 
          (SELECT AVG(Salary) 
           FROM Employees e2 
           WHERE e2.Department = e.Department 
           AND e2.EmployeeID != e.EmployeeID), 2) AS ImpactValue,
    CASE 
        WHEN ROUND(d.OverallAvg - 
                   (SELECT AVG(Salary) 
                    FROM Employees e2 
                    WHERE e2.Department = e.Department 
                    AND e2.EmployeeID != e.EmployeeID), 2) > 200 
        THEN 'تأثیر بالا 🚀'
        WHEN ROUND(d.OverallAvg - 
                   (SELECT AVG(Salary) 
                    FROM Employees e2 
                    WHERE e2.Department = e.Department 
                    AND e2.EmployeeID != e.EmployeeID), 2) > 50 
        THEN 'تأثیر متوسط 📊'
        ELSE 'تأثیر کم 📉'
    END AS ImpactLevel
FROM Employees e
INNER JOIN DeptAvg d ON e.Department = d.Department
ORDER BY ImpactValue DESC;
