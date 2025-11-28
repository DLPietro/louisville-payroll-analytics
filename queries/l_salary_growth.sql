-- Query 10: Salary Growth by Department (2020-2024)

WITH yearly_avg AS (
    SELECT 
        cal_year,
        department,
        ROUND(AVG(annual_rate), 2) AS avg_annual_rate,
        ROUND(AVG(ytd_total), 2) AS avg_ytd
    FROM salary_data
    WHERE cal_year IN (2020, 2021, 2022, 2023, 2024)
    GROUP BY cal_year, department
)
SELECT 
    department,
    MAX(CASE WHEN cal_year = 2020 THEN avg_annual_rate END) AS rate_2020,
    MAX(CASE WHEN cal_year = 2024 THEN avg_annual_rate END) AS rate_2024,
    ROUND(MAX(CASE WHEN cal_year = 2024 THEN avg_annual_rate END) - 
          MAX(CASE WHEN cal_year = 2020 THEN avg_annual_rate END), 2) AS absolute_increase,
    ROUND(((MAX(CASE WHEN cal_year = 2024 THEN avg_annual_rate END) - 
            MAX(CASE WHEN cal_year = 2020 THEN avg_annual_rate END)) / 
           MAX(CASE WHEN cal_year = 2020 THEN avg_annual_rate END)) * 100, 2) AS percent_increase
FROM yearly_avg
GROUP BY department
ORDER BY percent_increase DESC;