-- =============================================
-- تمرین ۷: GROUP BY با ستون دیگر
-- =============================================
-- هدف: تعداد کارمندان هر موقعیت شغلی

SELECT 
    Position,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Position
ORDER BY EmployeeCount DESC;