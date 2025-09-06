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

- Imported into PostgreSQL (Neon Cloud) using DBeaver (CSV → Table mapping).
- Connect Neon to Mode Analytics using PostgreSQL connector.
- SQL Query on Mode (Đối với từng bước query sẽ xuất 1 data result (check folder Data. Lưu ý: Data Result mặc định chỉ xuất ra được 100 rows)
  + I. EDA sơ bộ
    - I.1. Type
    - I.2. Check %Blank/null
      + I.2.1. Xử lý Blank/Null trong các cột: director, cast, country
    - I.3. Check %Zero value
    - I.4: I.4. Check outliers (Dùng IQR)
      --> Outlier detection using the IQR method flagged 41 records in date_added and ~100 records in release_year as potential outliers. However, upon inspection, these values are still meaningful and consistent with the business context (e.g., valid release years or valid added dates with fewer records). Therefore, all these records were retained for analysis.
  + II. Query
- Using **Mode for Dashboard** visualize

_**Key Findings**_

_**Actionable Plans**_

**E. Appendix**

**About Me**

Hi, I'm Navin (Bao Vy) – an aspiring Data Analyst passionate about turning raw data into actionable business insights. I’m eager to contribute to data-driven decision making and help organizations translate analytics into business impact. For more details, please reach out at:

🌐 LinkedIn: https://www.linkedin.com/in/navin826/

📂 Portfolio: https://github.com/CallmeNavin/
