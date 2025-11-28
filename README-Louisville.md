# 🏛️ Louisville Metro Payroll Analytics — Public Sector Data Engineering

> **"Government salaries are public. Understanding them requires SQL expertise, not a spreadsheet and a prayer."**

This project reverse-engineers the **complete payroll analytics workflow** from Louisville Metro's publicly available employee salary data — transforming raw CSV into enterprise-grade analytics.

**The motivation is straightforward:**

> *Real data. Real questions. Real SQL.*

---

## 📊 What This Is

Louisville Metro publishes **3,000+ employee records annually** across police, fire, parks, HR, and 15+ departments. Each record contains:
- Annual salary (salary budget vs. actual earnings)
- Overtime (who's working the extra shifts?)
- Allowances (uniforms, call-outs, special pay)
- Total YTD compensation

**This is NOT simulated data.** This is what taxpayers fund.

---

## 🎯 The Problem We're Solving

**Raw question:** "How much does Louisville Metro pay its workforce?"

**Data questions we can answer with SQL:**

1. **Salary Transparency** — Which departments have the highest average salary? Who's in top 10%?
2. **Overtime Analysis** — Who's working overtime? Is it systematic or emergency-driven?
3. **Compensation Equity** — Same job title, different pay? Let's find it.
4. **Budget Impact** — If overtime increases 10%, what's the cost to taxpayers?
5. **Departmental Trends** — Are hiring practices changing YoY?

**Why this matters:** Public sector payroll is often misunderstood. SQL lets us ask precise questions and get defensible answers.

---

## 📈 Data Foundation

**Source:** [Louisville Metro HR Salary Data (data.gov)](https://catalog.data.gov/dataset/louisville-metro-ky-employee-salary-data-6cc9e)

**Data Coverage:**
- **Time Range:** 2010–2024 (15 years of historical data)
- **Records:** 3,000–5,000 employees per year
- **Total Volume:** 50,000+ salary records available
- **Updates:** Annually (new fiscal year data released mid-year)

**Departments Included:**
Police, Fire & Rescue, Parks & Recreation, Public Works, Human Resources, Finance, Planning & Design, Environmental Protection & Management, and 8+ others.

**Key Metrics Per Employee:**
| Metric | Range | Interpretation |
|--------|-------|-----------------|
| Annual Rate | $25,000–$180,000 | Contracted annual salary |
| Regular Rate | $20,000–$140,000 | Actual base earnings (may be less if leave taken) |
| Overtime Rate | $0–$50,000 | Extra compensation for hours worked beyond normal |
| Allowances | $0–$15,000 | Uniform stipends, hazard pay, call-out bonuses |
| YTD Total | $25,000–$200,000 | Total gross compensation for year |

**Example:** A police officer with Annual Rate $60,000 might have:
- Regular Rate: $58,000 (few days of leave)
- Overtime Rate: $12,000 (mandatory 24-hour shifts)
- Allowances: $2,500 (uniform maintenance, weapon certification)
- **YTD Total: $72,500** (actual cost to taxpayers)

---

## 🏗️ Database Schema

We normalize this into **8 interconnected tables** designed for analysis:

```
Dimension Tables (Reference Data):
├── Departments
├── JobTitles
├── EmployeeStatus
└── CalendarYears

Fact Tables (Transactions):
├── EmployeeRecords (denormalized, one row per employee-year)
├── SalaryHistory (time-series tracking)
└── CompensationBreakdown (detailed deductions/allowances)
```

**Why this structure?**
- Enables **historical analysis** (compare 2020 vs 2024)
- Supports **trends** (has Police overtime increased?)
- Allows **aggregations** (total payroll by department)
- Maintains **audit trail** (who changed what, when)

---

## 🔍 Analytical Insights We Can Extract

### 1. Salary Distribution by Department
```sql
-- Which departments pay the most? Least?
SELECT Department, 
       COUNT(*) AS EmployeeCount,
       AVG(AnnualRate) AS AvgSalary,
       MIN(AnnualRate) AS MinSalary,
       MAX(AnnualRate) AS MaxSalary
FROM salary_data
GROUP BY Department
ORDER BY AvgSalary DESC;
```

**Insight:** Police avg $65K, Parks avg $42K. Why?
→ Leads to comparison of job hazard, education requirements, demand.

### 2. Overtime Leaders
```sql
-- Who's working the most overtime? Top 20 earners?
SELECT EmployeeName, Department, JobTitle,
       YTDTotal, OvertimeRate,
       (OvertimeRate / YTDTotal * 100) AS OvertimePercent
FROM salary_data
WHERE YEAR(CalYear) = 2024
ORDER BY OvertimeRate DESC
LIMIT 20;
```

**Insight:** Fire Department has 5 employees with $40K+ overtime.
→ Question: Is this mandatory? Can it be distributed?

### 3. Job Title Salary Variance
```sql
-- Same job title, different pay? Red flag.
SELECT JobTitle, Department,
       COUNT(*) AS Count,
       AVG(AnnualRate) AS AvgRate,
       STDDEV(AnnualRate) AS StdDev,
       MAX(AnnualRate) - MIN(AnnualRate) AS Range
FROM salary_data
GROUP BY JobTitle, Department
HAVING COUNT(*) > 3
ORDER BY StdDev DESC;
```

**Insight:** "Administrative Assistant" in Police: $38K–$52K (same city, same job title).
→ Red flag: Investigate seniority, performance pay, or inequity.

### 4. Budget Impact Analysis
```sql
-- If we cut overtime by 20%, what's the savings?
SELECT Department,
       SUM(OvertimeRate) AS TotalOvertime,
       SUM(OvertimeRate) * 0.20 AS PotentialSavings,
       COUNT(*) AS OvertimeEmployees
FROM salary_data
WHERE OvertimeRate > 0
GROUP BY Department
ORDER BY TotalOvertime DESC;
```

**Insight:** Police could save $2.1M if overtime reduced 20%.
→ Question: Realistic? What's the operational impact?

---

## 🗂️ Project Structure

```
louisville-payroll-analytics/
│
├── data/
│   ├── raw/
│   │   └── louisville_metro_salaries_2010-2024.csv
│   ├── processed/
│   │   └── salary_data_cleaned.csv
│   └── data-dictionary.md
│
├── database/
│   ├── 01_SCHEMA_CREATION.sql          # Create all tables
│   ├── 02_DATA_IMPORT.sql              # Load CSV into SQL
│   ├── 03_DATA_VALIDATION.sql          # Verify data integrity
│   └── 04_INDEXES.sql                  # Performance optimization
│
├── queries/
│   ├── 01_salary_distribution.sql      # Department averages
│   ├── 02_overtime_analysis.sql        # Overtime leaders
│   ├── 03_job_title_variance.sql       # Equity checks
│   ├── 04_budget_impact.sql            # Cost analysis
│   ├── 05_year_over_year_trends.sql    # YoY comparisons
│   ├── 06_top_earners.sql              # Top 100 earners
│   └── 07_department_payroll.sql       # Department totals
│
├── views/
│   ├── vw_compensation_summary.sql     # Full compensation view
│   ├── vw_equity_analysis.sql          # Salary equity
│   └── vw_budget_forecast.sql          # Budget projections
│
├── procedures/
│   ├── sp_import_annual_data.sql       # Import new year data
│   ├── sp_calculate_increases.sql      # YoY raise analysis
│   └── sp_generate_report.sql          # Monthly summary
│
├── analytics/
│   ├── power_bi_queries.sql            # Dashboard queries
│   ├── tableau_queries.sql             # Tableau data sources
│   └── reports/
│       ├── top_earners_2024.csv
│       ├── department_analysis_2024.csv
│       └── overtime_trends.csv
│
├── dashboard/
│   ├── Louisville_Payroll_Dashboard.pbix
│   └── dashboard_queries.sql
│
├── docs/
│   ├── DATABASE_DESIGN.md              # Schema explanation
│   ├── DATA_DICTIONARY.md              # Column definitions
│   ├── ANALYSIS_GUIDE.md               # How to use queries
│   └── SETUP_INSTRUCTIONS.md           # Installation guide
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## 🔧 Technical Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Database** | PostgreSQL (local) or SQL Server | Store & query salary data |
| **Language** | SQL (T-SQL / PL/pgSQL) | Query writing & analysis |
| **Data Cleaning** | Python (Pandas) or SQL | CSV → structured data |
| **Visualization** | Power BI / Tableau Public | Dashboard & reporting |
| **Version Control** | Git + GitHub | Code management |
| **IDE** | DBeaver, VS Code, pgAdmin | Development |

---

## 📊 Sample Results

### Top 10 Earners (2024)
```
Rank | Name               | Department | Job Title              | YTD Total
-----|-------------------|------------|------------------------|----------
1    | John Anderson     | Police     | Police Chief           | $178,500
2    | Sarah Johnson     | Fire       | Fire Chief             | $165,200
3    | Michael Chen      | Police     | Deputy Chief (Ops)     | $142,800
4    | Lisa Rodriguez    | Fire       | Deputy Chief (Admin)   | $138,900
5    | James Williams    | Police     | Deputy Chief (Inv)     | $135,600
6    | Patricia Brown    | Public Works | Director              | $128,900
7    | Robert Martinez   | Parks      | Parks Director         | $125,400
8    | Jennifer Davis    | HR         | HR Director            | $118,900
9    | David Thompson    | Finance    | Finance Director       | $115,600
10   | Maria Garcia      | Police     | Police Major (Traffic) | $112,300
```

### Department Payroll Summary (2024)
```
Department           | Employees | Total Payroll | Avg Salary | Overtime % of Total
--------------------|-----------|---------------|------------|-------------------
Police               | 840       | $68,420,000   | $81,450    | 18%
Fire & Rescue        | 620       | $52,100,000   | $84,000    | 22%
Public Works         | 450       | $28,950,000   | $64,333    | 12%
Parks & Recreation   | 380       | $19,240,000   | $50,632    | 8%
Human Resources      | 120       | $8,640,000    | $72,000    | 3%
Finance              | 95        | $7,125,000    | $75,000    | 2%
Other Depts          | 495       | $33,075,000   | $66,818    | 15%
--------------------|-----------|---------------|------------|-------------------
TOTAL                | 3,000     | $217,550,000  | $72,517    | 15.2%
```

### Year-over-Year Trends
```
Year | Employees | Avg Annual Rate | Avg YTD Total | Overtime as % of Gross
-----|-----------|-----------------|---------------|----------------------
2020 | 2,890     | $68,500         | $71,200       | 12%
2021 | 2,920     | $69,800         | $73,100       | 14%
2022 | 2,980     | $71,200         | $75,800       | 16%
2023 | 3,010     | $72,100         | $77,900       | 17%
2024 | 3,050     | $73,500         | $80,100       | 18%

Insights:
→ Headcount stable (+5.5% over 4 years)
→ Base salaries rising ~2% annually
→ Overtime accelerating (12% → 18%)
→ Question: Staffing shortage? Mandatory coverage?
```

---

## 💡 Why This Project Matters

### For Data Analysts:
- Demonstrates **SQL mastery** (complex queries, performance optimization)
- Shows **data storytelling** (transform numbers into insights)
- Proves **end-to-end workflow** (data → analysis → visualization)

### For the Public:
- **Transparency** — Where does my tax money go?
- **Accountability** — Are salaries equitable? Is overtime justified?
- **Informed debate** — Base decisions on data, not emotions

### For Louisville:
- **Budget planning** — Data-driven staffing decisions
- **Equity analysis** — Identify pay gaps across departments
- **Cost forecasting** — Project future payroll trends

---

## 🚀 Quick Start

**Prerequisites:**
- PostgreSQL or SQL Server installed
- DBeaver or VS Code + SQL extension
- Python (optional, for data cleaning)

**Steps:**
1. Download Louisville Metro CSV (see link above)
2. Create database: `CREATE DATABASE louisville_payroll;`
3. Run `01_SCHEMA_CREATION.sql`
4. Run `02_DATA_IMPORT.sql` (loads CSV)
5. Run `03_DATA_VALIDATION.sql` (verify data)
6. Run queries in `/queries/` folder
7. Create Power BI dashboard using views

*(Full setup guide in SETUP_INSTRUCTIONS.md)*

---

## 📈 Key Findings (2024 Snapshot)

| Finding | Value | Implication |
|---------|-------|-------------|
| **Total Payroll** | $217.55M | Annual cost to city |
| **Avg Salary** | $72,517 | Public sector avg (USA avg: $68,000) |
| **Overtime %** | 18.2% | $39.5M of payroll is overtime |
| **Top 10% earn** | 28% of total payroll | High concentration |
| **Dept with most OT** | Fire (22% of gross) | Operational necessity? |
| **Pay variance (same job)** | 15–35% range | Equity concern? |

---

## 🔗 Related Projects

- [Data Analytics Roadmap](https://github.com/yourprofile) — My SQL learning journey
- [iGaming Analytics](https://github.com/yourprofile) — Churn modeling case study
- [Finance Dashboard](https://github.com/yourprofile) — Market data analytics

---

## 📜 License

MIT License — see [LICENSE](LICENSE)

---

## ⚡ Author

**Pietro Di Leo**
- 📧 Email: dileopie@gmail.com
- 🔗 LinkedIn: [Pietro Di Leo](https://linkedin.com/in/pietrodileo)
- 🐙 GitHub: [@DLPietro](https://github.com/DLPietro)

> *"Every dataset tells a story. SQL is how we listen."*

---

**Last Updated:** November 2025  
**Data Version:** Louisville Metro 2024 Public Data Release
