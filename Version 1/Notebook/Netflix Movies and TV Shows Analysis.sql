-- I. Basic EDA
--- I.1. Check Column Type
SELECT
  column_name
  , data_type
from information_schema.columns
WHERE table_schema = 'public'
and table_name = 'netflix_titles';
--- I.2. Check %Blank/Null
SELECT 
  SUM(CASE WHEN show_id is Null or show_id = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_show_id
  , SUM(Case WHEN "type" is Null or "type" = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_type
  , SUM(Case WHEN title is Null or title = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_title
  , SUM(Case WHEN director is Null or director = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_director
  , SUM(Case WHEN "cast" is Null or "cast" = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_cast
  , SUM(Case WHEN country is Null or country = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_country
  , SUM(Case WHEN date_added is Null then 1 Else 0 End)*100/COUNT(*) as pct_blank_date_added
  , SUM(Case WHEN release_year is Null then 1 Else 0 End)*100/COUNT(*) as pct_blank_release_year
  , SUM(Case WHEN rating is Null or rating = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_rating
  , SUM(Case WHEN duration is Null or duration = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_duration
  , SUM(Case WHEN listed_in is Null or listed_in = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_listed_in
  , SUM(Case WHEN description is Null or description = '' then 1 Else 0 End)*100/COUNT(*) as pct_blank_description
FROM public.netflix_titles;
---- I.2.1. Handling Blank/Null values
CREATE TABLE netflix_titles_clean AS 
Select
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , date_added
  , release_year
  , rating
  , duration
  , listed_in
  , description
from public.netflix_titles;
SELECT * FROM netflix_titles_clean;
--- I.3. Check %Zero Value
SELECT
  SUM(Case When date_added is NULL then 1 Else 0 End)*100/COUNT(*) as pct_zero_date_added
  , SUM(Case When release_year = 0 then 1 Else 0 End)*100/COUNT(*) as pct_zero_release_year
from netflix_titles_clean;
--- I.4. Check Outliers (IQR method)
---- I.4.1. Check outliers (release_year)
WITH 
  cleaned_release_year AS(
    Select
        show_id
        , "type"
        , title
        , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
        , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
        , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
        , date_added
        , release_year
        , rating
        , duration
        , listed_in
        , description
    from public.netflix_titles),
  stats AS(
    SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY release_year) as q1
      , PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY release_year) as q3
      FROM cleaned_release_year),
  bounds AS(
    SELECT
      q1
      , q3
      , (q3 - q1) as iqr
      , (q1 - 1.5 * (q3 - q1)) as lower_bound
      , (q1 + 1.5 * (q3 - q1)) as upper_bound
    FROM stats)
SELECT
  cleaned_release_year.*
FROM cleaned_release_year, bounds
WHERE cleaned_release_year.release_year < bounds.lower_bound
OR cleaned_release_year.release_year > bounds.upper_bound;
---- I.4. Check Outliers (date_added)
WITH 
  cleaned_date_added AS(
    Select
      show_id
      , "type"
      , title
      , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
      , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
      , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
      , date_added
      , release_year
      , rating
      , duration
      , listed_in
      , description
    from public.netflix_titles),
  stats_date_added AS(
    SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY EXTRACT(EPOCH from date_added)) as q1_date_added
      , PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY EXTRACT(EPOCH from date_added)) as q3_date_added
    from cleaned_date_added),
    bounds_date_added AS(
      SELECT
        q1_date_added
        , q3_date_added
        , (q3_date_added - q1_date_added) as iqr_date_added
        , (q1_date_added - 1.5 * (q3_date_added - q1_date_added)) as lower_bound_date_added
        , (q1_date_added + 1.5 * (q3_date_added - q1_date_added)) as upper_bound_date_added
      FROM stats_date_added)
SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM cleaned_date_added, bounds_date_added
WHERE EXTRACT(EPOCH from cleaned_date_added.date_added) < lower_bound_date_added
OR EXTRACT(EPOCH from cleaned_date_added.date_added) > upper_bound_date_added;
-- II. Query for Insights
--- II.1. Content by factors
---- II.1.1. No of Content by Country
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT 
  country
  , COUNT(*) as total_contents
  , ROUND(100 * COUNT(*)/SUM(COUNT(*)) Over (), 2) as pct_total_contents
from full_data_cleaned
Group by country
Order by total_contents DESC;
---- II.1.2. No of Content by listed_in
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT
  listed_in
  , COUNT(*) as total_titles
  , ROUND(100* COUNT(*)/SUM(COUNT(*)) OVER (), 2) as pct_total_titles
from full_data_cleaned
Group by listed_in
Order by total_titles DESC;
---- II.1.3. No of Content by type
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT
  "type"
  , COUNT(*) as total_titles
  , ROUND(100* COUNT(*)/SUM(COUNT(*)) OVER (), 2) as pct_total_titles
from full_data_cleaned
Group by "type"
Order by total_titles DESC;
---- II.1.4. No of Content by rating
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT
  rating
  , COUNT(*) as total_titles
  , ROUND(100* COUNT(*)/SUM(COUNT(*)) OVER (), 2) as pct_total_titles
from full_data_cleaned
Group by rating
Order by total_titles DESC;
--- II.2. Group by Country
---- II.2.1. Country + Type
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT
  country
  , "type"
  , COUNT(*) as total_titles
  , ROUND(100* COUNT(*)/SUM(COUNT(*)) OVER (), 2) as pct_total_titles
from full_data_cleaned
Group by Country, "type"
Order by total_titles DESC;
---- II.2.2. Country + Rating
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles)
SELECT
  country
  , rating
  , COUNT(*) as total_titles
  , ROUND(100* COUNT(*)/SUM(COUNT(*)) OVER (), 2) as pct_total_titles
from full_data_cleaned
Group by Country, rating
Order by total_titles DESC;
--- II.3. Identifying similar content (by text-based feature)
WITH full_data_cleaned AS(
  SELECT
    show_id
    , "type"
    , title
    , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
    , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
    , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
    , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
    , release_year
    , rating
    , duration
    , listed_in
    , description
  FROM public.netflix_titles),
    genre_split AS(
      SELECT
        show_id
        , "title"
        , UNNEST(STRING_TO_ARRAY(listed_in, ',')):: TEXT AS genre
      FROM full_data_cleaned)
SELECT
  TRIM(genre) as genre_clean
  , COUNT(*) as total_titles
FROM genre_split
Group by genre_clean
Order by total_titles DESC;
WITH full_data_cleaned AS(
  SELECT
    show_id
    , "type"
    , title
    , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
    , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
    , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
    , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
    , release_year
    , rating
    , duration
    , listed_in
    , description
  FROM public.netflix_titles),
    genre_split AS(
      SELECT
        show_id
        , "title"
        , UNNEST(STRING_TO_ARRAY(listed_in, ',')):: TEXT AS genre
      FROM full_data_cleaned),
    pairs AS(
      SELECT
        a.show_id as show_id_a
        , b.show_id as show_id_b
        , COUNT(*) AS shared_genres
      FROM genre_split a
      JOIN genre_split b
      ON a.genre = b.genre
      AND a.show_id < b.show_id
      Group by a.show_id, b.show_id)
SELECT * from pairs
WHERE shared_genres >= 2
ORDER BY shared_genres DESC
LIMIT 50;
WITH full_data_cleaned AS(
  SELECT
    show_id
    , "type"
    , title
    , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
    , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
    , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
    , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
    , release_year
    , rating
    , duration
    , listed_in
    , description
  FROM public.netflix_titles)
SELECT 
  show_id
  , "title"
  , release_year
  , description
from full_data_cleaned
WHERE LOWER(description) LIKE '%crime%'
ORDER BY release_year DESC 
LIMIT 50;
--- II.4. Movies & TV Show trend through Years
WITH full_data_cleaned AS(
  SELECT
  show_id
  , "type"
  , title
  , COALESCE(NULLIF(TRIM(director),''), 'Unknown Director') as director
  , COALESCE(NULLIF(TRIM("cast"),''), 'Unknown Cast') as cast
  , COALESCE(NULLIF(TRIM(country), ''), 'Unknown Country') as country
  , TO_CHAR(date_added, 'YYYY-MM-DD') as date_added_cleaned
  , release_year
  , rating
  , duration
  , listed_in
  , description
FROM public.netflix_titles),
  base AS(
    SELECT 
      release_year
      , "type"
    FROM full_data_cleaned
    WHERE release_year is not NULL),
  year_total AS(
    SELECT
      release_year
      , COUNT(*) as total
    FROM base
    Group by release_year),
  year_type AS(
    SELECT
      release_year
      , "type"
      , COUNT(*) as cnt
    FROM base
    GROUP BY release_year, "type")
SELECT
  y.release_year
  , ROUND(100 * SUM(CASE WHEN y."type" = 'Movie' then y.cnt else 0 END)/t.total, 2) AS pct_movie
  , ROUND(100 * SUM(CASE WHEN y."type" = 'TV Show' then y.cnt else 0 END)/t.total, 2) AS pct_tv_show
FROM year_type y 
JOIN year_total t USING(release_year)
GROUP BY y.release_year, t.total
ORDER BY y.release_year DESC; 