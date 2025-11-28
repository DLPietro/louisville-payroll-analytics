-- Query 3: Overtime per Department

SELECT 
    department,
    COUNT(*) AS employees_with_ot,
    ROUND(SUM(overtime_rate), 2) AS total_ot_cost,
    ROUND(AVG(overtime_rate), 2) AS avg_ot_per_employee,
    ROUND(SUM(overtime_rate) / NULLIF(SUM(ytd_total), 0) * 100, 2) AS ot_percent_of_gross,
    MAX(overtime_rate) AS max_ot_individual
FROM salary_data
WHERE cal_year = 2024 AND overtime_rate > 0
GROUP BY department
ORDER BY total_ot_cost DESC;