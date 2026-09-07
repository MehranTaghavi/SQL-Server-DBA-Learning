-- =============================================
-- تمرین ۱۹: آمار کامل هر بخش
-- =============================================
-- هدف: نمایش همه آمارهای هر بخش با نام‌های مناسب

SELECT 
    Department as بخش,
    COUNT(*) as تعداد_کارمندان,
    AVG(Salary) as میانگین_حقوق,
    MAX(Salary) as بیشترین_حقوق,
    MIN(Salary) as کمترین_حقوق,
    SUM(Salary) as مجموع_حقوق,
    MAX(Salary) - MIN(Salary) as تفاوت_حقوق
FROM Employees
GROUP BY Department
ORDER BY میانگین_حقوق DESC;