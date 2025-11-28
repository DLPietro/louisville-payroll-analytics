-- Query 4: Salary Variance per job title (equity check)

SELECT 
    job_title,
    department,
    COUNT(*) AS num_employees,
    ROUND(AVG(annual_rate), 2) AS avg_rate,
    ROUND(MIN(annual_rate), 2) AS min_rate,
    ROUND(MAX(annual_rate), 2) AS max_rate,
    ROUND(MAX(annual_rate) - MIN(annual_rate), 2) AS salary_range,
    ROUND(STDDEV(annual_rate), 2) AS stddev
FROM salary_data
WHERE cal_year = 2024
GROUP BY job_title, department
HAVING COUNT(*) >= 3
ORDER BY stddev DESC
LIMIT 30;