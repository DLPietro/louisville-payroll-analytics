-- Query 6: Budget Impact - What happens if we reduce overtime?

SELECT 
    department,
    ROUND(SUM(overtime_rate), 2) AS current_ot_cost,
    ROUND(SUM(overtime_rate) * 0.20, 2) AS savings_20_percent_reduction,
    ROUND(SUM(overtime_rate) * 0.30, 2) AS savings_30_percent_reduction,
    COUNT(DISTINCT employee_name) AS employees_with_ot,
    ROUND(SUM(ytd_total), 2) AS total_dept_payroll,
    ROUND(SUM(overtime_rate) / NULLIF(SUM(ytd_total), 0) * 100, 2) AS ot_as_percent
FROM salary_data
WHERE cal_year = 2024 AND overtime_rate > 0
GROUP BY department
ORDER BY current_ot_cost DESC;