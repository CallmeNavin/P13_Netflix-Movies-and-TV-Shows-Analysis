# P13_Netflix-Movies-and-TV-Shows-Analysis

**VERSION 1**

**A. Project Overview**

- Understanding what content is available in different countries
- Identifying similar content by matching text-based features
- Network analysis of Actors / Directors and find interesting insights
- Does Netflix has more focus on TV Shows than movies in recent years
- Cohort/Churn Viewer
- Recommendations

**B. Dataset Information**

_**Source**_

- Name: Netflix Movies and TV Shows (From Kaggle)
- https://www.kaggle.com/datasets/shivamb/netflix-shows/data 

_**Period**_

**C. Methodology**

- Imported Data: Dataset was imported into PostgreSQL (Neon Cloud) using DBeaver (CSV → Table mapping).
- Connection: Connected Neon Cloud to Mode Analytics through the PostgreSQL connector.
- SQL Queries: Executed directly in Mode. Each step produces a separate query result (see folder Query Results). Mode’s default export limit is 100 rows per query result.
  + I. Basic EDA: 
    + I.1. Type: Identified column names and data types.
    + I.2. Check %Blank/Null. Detected missing values across key columns
    + I.2.1. Handling Blank/Null values: Replaced missing values in director, cast, and country with "Unknown Director", "Unknown Cast", and "Unknown Country".
    + I.3. Check %Zero Value: Checked for invalid zero values in date_added and release_year.
    + I.4. Check Outliers (IQR method):
      - Applied IQR method to detect potential outliers in date_added and release_year.
      - Result: Outlier detection flagged 41 records in date_added and ~100 records in release_year as potential outliers. Upon inspection, these values are still meaningful and consistent with the business context (e.g., valid release years or valid added dates with fewer records). Therefore, all records were retained for subsequent analysis.
  + II. Query for Insights:
- Using Mode for Dashboard visualize

_**Key Findings**_

_**Actionable Plans**_

**E. Appendix**

**About Me**

Hi, I'm Navin (Bao Vy) – an aspiring Data Analyst passionate about turning raw data into actionable business insights. I’m eager to contribute to data-driven decision making and help organizations translate analytics into business impact. For more details, please reach out at:

🌐 LinkedIn: https://www.linkedin.com/in/navin826/

📂 Portfolio: https://github.com/CallmeNavin/
