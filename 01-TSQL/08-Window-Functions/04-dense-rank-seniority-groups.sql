/* ============================================================
   Exercise 04 - DENSE_RANK: seniority groups by hire year
   ============================================================
   Uses the sample tables created by 00-setup.sql
   (from the CTE exercises folder).

   Goal: Group employees into seniority tiers based on the year
   they were hired. DENSE_RANK() gives the same tier number to
   employees hired in the same year, without leaving gaps in
   the numbering afterwards.
   ============================================================ */

SELECT
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    DENSE_RANK() OVER (ORDER BY YEAR(HireDate) ASC) AS SeniorityTier
FROM Employees
ORDER BY SeniorityTier, HireDate;