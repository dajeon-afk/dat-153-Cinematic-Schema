CREATE SCHEMA IF NOT EXISTS schema_clean;

DROP TABLE IF EXISTS schema_clean.movies;

CREATE TABLE schema_clean.movies AS
SELECT
    tconst AS imdb_id,
    TRIM("primaryTitle") AS title,

    CASE
        WHEN "startYear" ~ '^[0-9]{4}$'
        THEN MAKE_DATE("startYear"::INTEGER, 1, 1)
        ELSE NULL
    END AS release_date,

    CASE
        WHEN "runtimeMinutes" ~ '^[0-9]+$'
             AND "runtimeMinutes"::NUMERIC
                 BETWEEN 1 AND 2147483647
        THEN "runtimeMinutes"::INTEGER
        ELSE NULL
    END AS runtime,

    genres
FROM schema_temporary.title_basics
WHERE "titleType" = 'movie'
  AND tconst IS NOT NULL
  AND tconst <> '\N'
  AND "primaryTitle" IS NOT NULL
  AND TRIM("primaryTitle") NOT IN ('', '\N');

-- STEP 2: Extract and normalize genres
CREATE TABLE schema_clean.genres AS
SELECT DISTINCT
    TRIM(genre_value) AS genre_name
FROM schema_clean.movies
CROSS JOIN LATERAL
    UNNEST(STRING_TO_ARRAY(genres, ',')) AS genre_value
WHERE TRIM(genre_value) NOT IN ('', '\N');

-- Check the results
SELECT *
FROM schema_clean.genres
ORDER BY genre_name;