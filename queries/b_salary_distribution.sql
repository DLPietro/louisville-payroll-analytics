-- Query 1: Salary distribution per department (all-time)

SELECT 
    department,
    COUNT(*) AS employee_count,
    ROUND(MIN(annual_rate), 2) AS min_annual,
    ROUND(AVG(annual_rate), 2) AS avg_annual,
    ROUND(MAX(annual_rate), 2) AS max_annual,
    ROUND(STDDEV(annual_rate), 2) AS salary_stddev,
    ROUND(SUM(ytd_total), 2) AS total_payroll
FROM salary_data
WHERE cal_year = 2024
GROUP BY department
ORDER BY avg_annual DESC;