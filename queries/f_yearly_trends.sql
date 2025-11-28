-- Query 5: Yearly Trend (2020-2024)

SELECT 
    cal_year,
    COUNT(*) AS employee_count,
    ROUND(AVG(annual_rate), 2) AS avg_annual_rate,
    ROUND(AVG(ytd_total), 2) AS avg_ytd_total,
    ROUND(SUM(ytd_total), 2) AS total_payroll,
    ROUND(SUM(overtime_rate) / NULLIF(SUM(ytd_total), 0) * 100, 2) AS overtime_percent
FROM salary_data
WHERE cal_year >= 2020
GROUP BY cal_year
ORDER BY cal_year ASC;