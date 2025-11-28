CREATE TABLE salary_data (
    id SERIAL PRIMARY KEY,
    cal_year INT NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    job_title VARCHAR(150) NOT NULL,
    annual_rate NUMERIC(10, 2),
    regular_rate NUMERIC(10, 2),
    overtime_rate NUMERIC(10, 2),
    incentive_allowance NUMERIC(10, 2),
    other_payments NUMERIC(10, 2),
    ytd_total NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_department ON salary_data(department);
CREATE INDEX idx_cal_year ON salary_data(cal_year);
CREATE INDEX idx_job_title ON salary_data(job_title);
CREATE INDEX idx_ytd_total ON salary_data(ytd_total DESC);

CREATE VIEW v_department_summary AS
SELECT 
    cal_year,
    department,
    COUNT(*) AS employee_count,
    ROUND(AVG(annual_rate), 2) AS avg_annual_rate,
    ROUND(AVG(ytd_total), 2) AS avg_ytd_total,
    ROUND(SUM(ytd_total), 2) AS total_payroll,
    ROUND(AVG(overtime_rate), 2) AS avg_overtime
FROM salary_data
GROUP BY cal_year, department;

CREATE VIEW v_top_earners AS
SELECT 
    cal_year,
    employee_name,
    department,
    job_title,
    ytd_total,
    annual_rate,
    overtime_rate,
    ROW_NUMBER() OVER (PARTITION BY department, cal_year ORDER BY ytd_total DESC) AS rank_in_dept
FROM salary_data;

CREATE VIEW v_overtime_analysis AS
SELECT 
    cal_year,
    department,
    COUNT(*) AS employees_with_overtime,
    ROUND(SUM(overtime_rate), 2) AS total_overtime,
    ROUND(AVG(overtime_rate), 2) AS avg_overtime_per_employee,
    ROUND(SUM(overtime_rate) / NULLIF(SUM(ytd_total), 0) * 100, 2) AS overtime_percentage_of_gross
FROM salary_data
WHERE overtime_rate > 0
GROUP BY cal_year, department;
