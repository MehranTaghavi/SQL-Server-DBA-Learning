-- =============================================
-- تمرین ۸: GROUP BY چند ستون
-- =============================================
-- هدف: تعداد کارمندان هر ترکیب بخش و موقعیت

SELECT 
    Department,
    Position,
    COUNT(*) as EmployeeCount,
    AVG(Salary) as AvgSalary
FROM Employees
GROUP BY Department, Position
ORDER BY Department, Position;