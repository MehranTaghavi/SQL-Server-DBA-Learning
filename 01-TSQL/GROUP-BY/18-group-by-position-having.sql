-- =============================================
-- تمرین ۱۸: GROUP BY موقعیت با HAVING
-- =============================================
-- هدف: موقعیت‌هایی که میانگین حقوق آنها بالای ۷۵۰۰ است

SELECT 
    Position,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Position
HAVING AVG(Salary) > 7500
ORDER BY AvgSalary DESC;