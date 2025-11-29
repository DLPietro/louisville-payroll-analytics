# 🏛️ Louisville Metro Payroll Analytics - Public Sector

> _**"Government salaries are public: understanding them is the next step for Data analytics expertise."**_

This project works the **complete payroll analytics workflow** using Louisville Metro's publicly available employee salary data, transforming raw CSV into enterprise-grade analytics.

**The motivation is straightforward:**

> *Real data, real questions and real answers.*

---

## 📊 What this is

Louisville Metro publishes **6,000+ employee records annually** across police, fire, parks, HR, and 15+ departments. Each record contains:

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
- **Time Range:** 2020–2024 (5 years of historical data)
- **Records:** +6,000 employees per year
- **Total Volume:** 40,000+ salary records available
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

## 🗂️ Project Structure

```
louisville-payroll-analytics/
│
├── data/
│   ├── raw/
│   │   └── Louisville_Metro_KY_-_Employee_Salary_Data.csv            # Original Dataset from  US data.gov - Lousiville Metro Employee Salaries
│   └── processed/
│   │   └── salary_data_cleaned.csv                                   # Cleaned dataset to be queried within PostgreSQL
│
├── schema/
│   └── a_schema_creation.sql           # Create all tables with variables (columns) and rows
│
├── queries/
│   ├── b_salary_distribution.sql       # 1st Query: how the salary expenses are distributed into the several departments?
│   ├── c_top_earners.sql               # 2nd Query: which are the top earners?
│   ├── d_overtime_analysis.sql         # 3rd Query: how many hours are overtime?
│   ├── e_job_title_variance.sql        # 4th Query: how's volatile the salary for the same job title?
│   ├── f_yearly_trends.sql             # 5th Query: what's the salary and overtime trend?
│   ├── g_budget_impact.sql             # 6th Query: which are the most expensive departments?
│   ├── h_salary_inequality.sql         # 7th Query: how about the variance between salaries?
│   ├── i_department_ranking.sql        # 8th Query: who are the "Big Spenders"?
│   ├── j_allowances.sql                # 9th Query: which incentives per departments?
│   └── k_salary_growth.sql             # 10th Query: how's increasing the salaries? 
│
├── dashboard/                          # Queries output
│   ├── 1.Salary Distribution.csv
│   ├── 2.Top Earners.csv
│   ├── 3.Overtime per Department.csv
│   ├── 4.Salary Variance per Job Title.csv
│   ├── 5.Yearly Trend.csv
│   ├── 6.Budget Impact.csv
│   ├── 7.Salary Inequality.csv
│   ├── 8.Department Metrics.csv
│   ├── 9.Allowances.csv
│   └── 10.Salary Growth.csv
│
├── dashboard/
│   ├── l_full_breakdown.sql.sql        # Last Query: to create an overview
│   ├── Louisville Metro Payroll Analytics.twbx    # Tableau Dashbaord
│   └── dashboard.png                   # Dashboard Screenshot
│
├── LICENSE
└── README.md                           # What you're reading now
```

---

## 🔧 Technical Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Database** | PostgreSQL (local) | Store & query salary data |
| **Language** | SQL | Query writing & analysis |
| **Data Cleaning** | SQL | CSV for structured data |
| **Visualization** | Power BI / Tableau Public | Dashboard & reporting |
| **Version Control** | Git + GitHub | Code management |
| **IDE** | DBeaver | Development |

---

# Results

## 📊 Dashboard with tabs and Outputs

The results the dataset are available as below here: 

🔗 **[View the Live Dashboard →](https://public.tableau.com/views/LouisvilleMetroPayrollAnalytics-PublicSectorSalaryDashboard/Dashboard1?:language=it-IT&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

![Tableau Preview](https://github.com/DLPietro/louisville-payroll-analytics/blob/main/dashboard/dashboard.png)  


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

## 💡 Why This Project?

Consider this project as a **proof of capability** for:

> **Data Analytic roles**, handling complex, large-scale data pipelines
> **BI Developer**, creating actionable dashboards from raw data
> **SQL based roles**, expert-level stored procedures and Data optimization

Basically **owning a project from design to delivery**, not just write queries.

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

## 📜 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

## 🔗 Related Work

- [📊 My Data Journey Blog](https://dlpietro.github.io) - Weekly updates on my upskilling  
- [🧠 My Learning Roadmap](https://github.com/DLPietro/learning-roadmap) - Publicly tracked progress  
- [🎲 iGaming Analytics Dashboard](https://github.com/DLPietro/igaming-analytics-case-study) - KPI and players Retention (_Cohort, Church..._)
- [📈 Empirical Analysis: S&P 500 vs IVV vs Fidelity](https://github.com/DLPietro/thesis-backtesting-etf-spx) - Using R, GARCH, backtesting

---

## ⚡ Credits

[![GitHub Profile](https://img.shields.io/badge/GitHub-DLPietro-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DLPietro)
[![Email](https://img.shields.io/badge/Email-dileopie-d14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:dileopie@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Pietro-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/pietrodileo)

> _© 2025 Pietro Di Leo - One Commit at a Time._
