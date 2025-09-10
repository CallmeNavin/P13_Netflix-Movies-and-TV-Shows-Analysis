# P13_Netflix-Movies-and-TV-Shows-Analysis

**VERSION 1**

**A. Project Overview**

- Understanding what content is available in different countries
- Identifying similar content by matching text-based features
- Does Netflix has more focus on TV Shows than movies in recent years?

![Movies & TV Show rate through Years](https://github.com/CallmeNavin/P13_Netflix-Movies-and-TV-Shows-Analysis/blob/main/Version%201/Visualization/Movies%20%26%20TV%20Show%20rate%20through%20Years.png)

**B. Dataset Information**

_**Source**_

- Name: Netflix Movies and TV Shows (From Kaggle)
- https://www.kaggle.com/datasets/shivamb/netflix-shows/data 

_**Period**_

- From 1925 to 2021

**C. Methodology**

- Imported Data: Dataset was imported into PostgreSQL (Neon Cloud) using DBeaver (CSV → Table mapping).
- Connection: Connected Neon Cloud to Mode Analytics through the PostgreSQL connector.
- SQL Queries: Executed directly in Mode. Each step produces a separate query result (see folder Query Results). Mode’s default export limit is 100 rows per query result.
  + I. Data Cleaning: 
    + I.1. Check Column Type: Identified column names and data types.
    + I.2. Check %Blank/Null. Detected missing values across key columns
    + I.2.1. Handling Blank/Null values: Replaced missing values in director, cast, and country with "Unknown Director", "Unknown Cast", and "Unknown Country".
    + I.3. Check %Zero Value: Checked for invalid zero values in date_added and release_year.
    + I.4. Check Outliers (IQR method):
      - Applied IQR method to detect potential outliers in date_added and release_year.
      - Result: Outlier detection flagged 41 records in date_added and ~100 records in release_year as potential outliers. Upon inspection, these values are still meaningful and consistent with the business context (e.g., valid release years or valid added dates with fewer records). Therefore, all records were retained for subsequent analysis.
  + II. Query for Insights:
    - II.1. Content by factors
      + II.1.1. No of Content by Country
      + II.1.2. No of Content by listed_in
      + II.1.3. No of Content by type
      + II.1.4. No of Content by rating
    - II.2. Group by Country
      + II.2.1. Country + Type
      + II.2.2. Country + Rating
    - II.3. Identifying similar content (by text-based feature)
      + Test multiple keywords in description ("crime", "love", "war", "magic". In this case, I used "crime") and also analyzed listed_in genres. Each test consistently retrieved meaningful subsets of titles, confirming the dataset is rich for further NLP or recommendation modeling.
    - II.4. Movies & TV Show trend through Years
- Using Mode for Dashboard visualize of some big idea

**D. Key Findings & Actionable Plans**

_**Key Findings**_

- United States, India have the largest share of content (32% & 11.04%). In the US, TV-MA is dominant (10.54%) while India, TV-14 leads (6.25%) → Netflix is strongly focused on these two major markets and should tailor content strategies accordingly.
- In both markets, movies remain the primary content type (23.37% in the US & 10.14% in India).
- By genre, Dramas, International Movies, and Documentaries are the top categories (4.11% & 4.08%) → Users tend to prefer in-depth, multi-cultural content.
- Movies account for ~70% of the catalog. However, after remaining stable for nearly 90 years, TV Shows began to rise and overtook Movies around 2020 → Netflix is redefining itself from a Movie-first to a TV Show-first platform.
- Ratings analysis shows TV-MA (36.41%) and TV-14 (24.53%) dominate → Netflix is targeting both mature audiences and teenagers.

_**Actionable Plans**_

- Localize and customize content for the two biggest markets: focus on Movies overall, but tailor TV-MA content for the US and TV-14 content for India.
- Collaborate with local studios to expand genre diversity, especially Drama and International Movies.
- Invest in original TV Shows to increase user retention and differentiate from competitors.

**VERSION 2**

**A. Project Overview**

- Network analysis of Actors / Directors and find interesting insights
- Does Netflix has more focus on TV Shows than movies in recent years
- Cohort/Churn Viewer

**About Me**

Hi, I'm Navin (Bao Vy) – an aspiring Data Analyst passionate about turning raw data into actionable business insights. I’m eager to contribute to data-driven decision making and help organizations translate analytics into business impact. For more details, please reach out at:

🌐 LinkedIn: https://www.linkedin.com/in/navin826/

📂 Portfolio: https://github.com/CallmeNavin/
