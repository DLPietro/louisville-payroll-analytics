-- Query 8: Department Ranking per metrics (2024)

WITH dept_metrics AS (
    SELECT 
        department,
        COUNT(*) AS emp_count,
        ROUND(AVG(annual_rate), 2) AS avg_salary,
        ROUND(SUM(ytd_total), 2) AS total_payroll,
        ROUND(AVG(overtime_rate), 2) AS avg_ot
    FROM salary_data
    WHERE cal_year = 2024
    GROUP BY department
)
SELECT 
    department,
    RANK() OVER (ORDER BY emp_count DESC) AS rank_by_headcount,
    RANK() OVER (ORDER BY avg_salary DESC) AS rank_by_avg_salary,
    RANK() OVER (ORDER BY total_payroll DESC) AS rank_by_total_payroll,
    RANK() OVER (ORDER BY avg_ot DESC) AS rank_by_overtime,
    emp_count,
    avg_salary,
    total_payroll,
    avg_ot
FROM dept_metrics
ORDER BY total_payroll DESC;