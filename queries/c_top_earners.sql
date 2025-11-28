-- Query 2: Top 20 earners (2024)

SELECT 
    employee_name,
    department,
    job_title,
    annual_rate,
    overtime_rate,
    incentive_allowance,
    other_payments as other,
    ytd_total,
    ROUND(overtime_rate / nullif(ytd_total, 0) * 100, 2) AS overtime_percent
FROM salary_data
WHERE cal_year = 2024
ORDER BY ytd_total DESC
LIMIT 20;