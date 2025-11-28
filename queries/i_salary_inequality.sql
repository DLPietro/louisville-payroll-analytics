-- Query 7: Equity Analysis, Salary Inequality

SELECT 
    job_title,
    COUNT(*) AS total_employees,
    ROUND(AVG(CASE WHEN annual_rate < 50000 THEN annual_rate END), 2) AS avg_under_50k,
    ROUND(AVG(CASE WHEN annual_rate >= 50000 AND annual_rate < 75000 THEN annual_rate END), 2) AS avg_50k_to_75k,
    ROUND(AVG(CASE WHEN annual_rate >= 75000 THEN annual_rate END), 2) AS avg_over_75k,
    ROUND(MAX(annual_rate) - MIN(annual_rate), 2) AS salary_range_max
FROM salary_data
WHERE cal_year = 2024
GROUP BY job_title
HAVING COUNT(*) >= 5
ORDER BY salary_range_max DESC
LIMIT 20;