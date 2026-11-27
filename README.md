# Customer-Service-Complaint-Analysis
# Customer Service & Complaint Analytics

## Project Overview

This project focuses on analyzing customer service operations and complaint management using SQL Server. The project is inspired by telecom and service based companies such as Telenor, Zong, Jazz, and other service providers.

The main objective is to explore customer complaints, identify common service issues, evaluate complaint resolution performance, analyze agent performance and understand customer satisfaction through data analysis.

This project demonstrates practical skills in SQL data cleaning, exploratory data analysis (EDA), advanced SQL analysis, and business problem solving.

**Note:** The dataset used in this project is synthetic and created for educational and portfolio purposes. It does not represent actual company or customer records.

## Project Objectives

- Clean and prepare raw customer service datasets.
- Identify common customer complaints and service issues.
- Analyze complaint trends across different periods.
- Evaluate complaint resolution time and service performance.
- Analyze customer satisfaction and reopened complaints.
- Examine agent workload and performance.
- Identify repeat customers and recurring service problems.
- Generate meaningful business insights from the data.

## Tools & Technologies

- **SQL Server:** Database creation, data cleaning, and analysis.
- **SQL Server Management Studio (SSMS):** Writing and executing SQL queries.
- **GitHub:** Project version control and documentation.


## Project Workflow

### 1. Database Creation & Data Loading

- Created the SQL Server database.
- Created raw tables for all four datasets.
- Imported CSV files using BULK INSERT.
- Preserved original raw data for comparison.

### 2. Data Profiling & Cleaning

Performed data quality checks to identify:

- Missing and NULL values.
- Duplicate records and IDs.
- Inconsistent text values and capitalization.
- Invalid dates and date formats.
- Invalid numeric values.
- Negative resolution hours and unusual outliers.
- Inconsistent categories and other data quality issues.

Created separate clean tables and applied appropriate cleaning transformations while keeping the raw tables unchanged.

### 3. Exploratory Data Analysis (EDA)

Performed exploratory analysis queries to understand:

- Customer distribution by city and segment.
- Complaint distribution by category, priority and status.
- Monthly and yearly complaint trends.
- Product and service complaint distribution.
- Agent workload.
- Customer satisfaction ratings.
- Average complaint resolution time.
- Complaint update frequency.

### 4. Advanced SQL Data Analysis

Performed advanced analysis queries to investigate business problems using:

- Common Table Expressions (CTEs).
- Window functions.
- LAG() and cumulative totals.
- RANK() and ROW_NUMBER().
- Subqueries and multiple table joins.
- Conditional aggregation.
- Date calculations and percentage analysis.

Advanced analysis includes:

- Month-over-month complaint growth.
- Repeat customer analysis.
- Customer segment complaint rates.
- Agent performance rankings.
- Average resolution time comparisons.
- Customer satisfaction analysis.
- Reopened complaint rates.
- Resolution time benchmarks.
- Recurring complaint analysis.
- Identification of problematic issue categories.

## Key Business Areas

The analysis focuses on five major business areas:

1. **Customer Analysis:** Customer segments, locations, and repeat complaints.
2. **Complaint Analysis:** Complaint trends, categories, priorities, and statuses.
3. **Agent Performance:** Complaint workload, resolution performance, and customer ratings.
4. **Service Quality:** Resolution times, reopened complaints, and recurring issues.
5. **Customer Satisfaction:** Rating distributions and satisfaction across complaint categories.

## Repository Structure

```text
Customer-Service-Complaint-Analytics/
│
├── Dataset/
│   ├── Customers_Raw.csv
│   ├── Complaints_Raw.csv
│   ├── Agents_Raw.csv
│   └── ComplaintUpdates_Raw.csv
│
├── SQL/
│   ├── 01_Database_and_Raw_Data_Loading.sql
│   ├── 02_Clean_Tables_Creation.sql
│   ├── 03_Customers_Data_Profiling.sql
│   ├── 04_Data_Cleaning.sql
│   ├── 05_Exploratory_Data_Analysis.sql
│   └── 06_Advanced_Data_Analysis.sql
│
│
└── README.md
```

## Conclusion

This project demonstrates an end-to-end SQL-based data analytics workflow, starting from raw data preparation and cleaning to exploratory and advanced business analysis.


