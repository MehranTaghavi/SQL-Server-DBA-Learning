-- =============================================
-- تمرین ۱۶: Subquery در FROM
-- =============================================
-- هدف: نمایش کارمندان با میانگین حقوق بخششان

SELECT 
    e.FirstName,
    e.LastName,
    e.Department,
    e.Salary,
    d.AvgSalary
FROM Employees e
INNER JOIN (
    SELECT Department, AVG(Salary) as AvgSalary
    FROM Employees
    GROUP BY Department
) d ON e.Department = d.Department
ORDER BY e.Department, e.Salary DESC;
