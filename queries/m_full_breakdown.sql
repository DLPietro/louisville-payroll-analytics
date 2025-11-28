-- Query 11: View per Power BI - Full compensation breakdown

CREATE OR REPLACE VIEW v_powerbi_salary_data AS
SELECT 
    sd.cal_year,
    sd.employee_name,
    sd.department,
    sd.job_title,
    sd.annual_rate,
    sd.regular_rate,
    sd.overtime_rate,
    sd.incentive_allowance,
    sd.other_payments,
    sd.ytd_total,
    ROUND((sd.overtime_rate / NULLIF(sd.ytd_total, 0) * 100), 2) AS overtime_pct,
    ROUND(((sd.incentive_allowance + sd.other_payments) / NULLIF(sd.ytd_total, 0) * 100), 2) AS allowances_pct,
    CASE 
        WHEN sd.ytd_total < 40000 THEN 'Entry Level'
        WHEN sd.ytd_total >= 40000 AND sd.ytd_total < 70000 THEN 'Mid Level'
        WHEN sd.ytd_total >= 70000 AND sd.ytd_total < 100000 THEN 'Senior'
        ELSE 'Executive'
    END AS salary_tier,
    RANK() OVER (PARTITION BY sd.department, sd.cal_year ORDER BY sd.ytd_total DESC) AS rank_in_dept
FROM salary_data sd;

-- Seleziona dalla view per verificare
SELECT * FROM v_powerbi_salary_data WHERE cal_year = 2024 LIMIT 100;