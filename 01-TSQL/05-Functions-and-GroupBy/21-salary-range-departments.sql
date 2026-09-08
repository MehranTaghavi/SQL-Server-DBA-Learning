-- =============================================
-- تمرین ۲۱: بخش‌هایی با پراکندگی حقوق بالا
-- =============================================
-- هدف: نمایش بخش‌هایی که:
-- 1. حداقل ۲ کارمند دارند
-- 2. فاصله بین بیشترین و کمترین حقوق آن‌ها بیشتر از ۱۵۰۰ است
-- 3. میانگین حقوق آن‌ها کمتر از ۸۰۰۰ نیست

SELECT 
    Department as بخش,
    COUNT(*) as تعداد_کارمندان,
    MIN(Salary) as کمترین_حقوق,
    MAX(Salary) as بیشترین_حقوق,
    MAX(Salary) - MIN(Salary) as دامنه_حقوق,
    AVG(Salary) as میانگین_حقوق
FROM Employees
GROUP BY Department
HAVING COUNT(*) >= 2
    AND MAX(Salary) - MIN(Salary) > 1500
    AND AVG(Salary) >= 8000
ORDER BY دامنه_حقوق DESC;
