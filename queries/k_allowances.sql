-- Query 9: Allowances Analysis

SELECT 
    department,
    COUNT(*) AS employees,
    ROUND(AVG(incentive_allowance), 2) AS avg_incentive,
    ROUND(SUM(incentive_allowance), 2) AS total_incentive,
    ROUND(AVG(other_payments), 2) AS avg_other,
    ROUND(SUM(other_payments), 2) AS total_other,
    ROUND((SUM(incentive_allowance) + SUM(other_payments)) / NULLIF(SUM(ytd_total), 0) * 100, 2) AS allowances_percent_of_gross
FROM salary_data
WHERE cal_year = 2024
GROUP BY department
ORDER BY allowances_percent_of_gross DESC;