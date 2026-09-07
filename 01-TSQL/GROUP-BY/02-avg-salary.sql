-- =============================================
-- تمرین ۲: AVG با GROUP BY
-- =============================================
-- هدف: میانگین حقوق هر بخش را محاسبه کنید

SELECT 
    Department,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;