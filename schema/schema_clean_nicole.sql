-- DAT 153 Sprint 04 | TEST-only IMDb normalization
-- Run in your personal cinema database AFTER loading schema_temporary.title_basics.
-- The schema_clean tables are INTERMEDIATE; they are not public production tables.
-- Re-running this script recreates only the three schema_clean tables below.

BEGIN;
CREATE SCHEMA IF NOT EXISTS schema_clean;

DROP TABLE IF EXISTS schema_clean.movie_genres;
DROP TABLE IF EXISTS schema_clean.genres;
DROP TABLE IF EXISTS schema_clean.movies;

-- One record per IMDb movie; deterministic numeric IDs for downstream joins.
-- IMDb only provides a startYear, not a verified full release date, so the
-- final release_date is left NULL; original year is retained for analysis.
CREATE TABLE schema_clean.movies AS
WITH valid_titles AS (
    SELECT DISTINCT ON (tconst)
        tconst AS imdb_id,
        BTRIM("primaryTitle") AS title,
        CASE WHEN "startYear" ~ '^[0-9]{4}$'
                  AND "startYear"::integer BETWEEN 1 AND 9999
             THEN "startYear"::integer ELSE NULL END AS release_year,
        CASE WHEN "runtimeMinutes" ~ '^[0-9]+$'
                  AND "runtimeMinutes"::numeric BETWEEN 1 AND 2147483647
             THEN "runtimeMinutes"::integer ELSE NULL END AS runtime,
        genres
    FROM schema_temporary.title_basics
    WHERE "titleType" = 'movie'
      AND tconst IS NOT NULL AND tconst <> ''
      AND "primaryTitle" IS NOT NULL
      AND BTRIM("primaryTitle") NOT IN ('', E'\\N')
    ORDER BY tconst
)
SELECT
    ROW_NUMBER() OVER (ORDER BY imdb_id)::integer AS movie_id,
    imdb_id,
    title,
    NULL::date AS release_date,
    release_year,
    runtime,
    genres
FROM valid_titles;

CREATE UNIQUE INDEX ON schema_clean.movies (movie_id);
CREATE UNIQUE INDEX ON schema_clean.movies (imdb_id);

-- One row per distinct genre, including deterministic IDs.
CREATE TABLE schema_clean.genres AS
WITH unique_genres AS (
    SELECT DISTINCT BTRIM(g.genre_text) AS genre_name
    FROM schema_clean.movies AS m
    CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(m.genres, ',')) AS g(genre_text)
    WHERE BTRIM(g.genre_text) NOT IN ('', E'\\N')
)
SELECT ROW_NUMBER() OVER (ORDER BY genre_name)::integer AS genre_id,
       genre_name
FROM unique_genres;

CREATE UNIQUE INDEX ON schema_clean.genres (genre_id);
CREATE UNIQUE INDEX ON schema_clean.genres (genre_name);

-- Many-to-many links: use the SAME movie/genre IDs assigned above.
CREATE TABLE schema_clean.movie_genres AS
SELECT DISTINCT m.movie_id, g.genre_id
FROM schema_clean.movies AS m
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(m.genres, ',')) AS x(genre_text)
JOIN schema_clean.genres AS g
  ON g.genre_name = BTRIM(x.genre_text);

CREATE UNIQUE INDEX ON schema_clean.movie_genres (movie_id, genre_id);
COMMIT;

-- Verification (read-only):
SELECT 'movies' AS table_name, COUNT(*) AS rows FROM schema_clean.movies
UNION ALL
SELECT 'genres', COUNT(*) FROM schema_clean.genres
UNION ALL
SELECT 'movie_genres', COUNT(*) FROM schema_clean.movie_genres;

SELECT m.imdb_id, m.title, m.release_year, g.genre_name
FROM schema_clean.movie_genres AS mg
JOIN schema_clean.movies AS m USING (movie_id)
JOIN schema_clean.genres AS g USING (genre_id)
ORDER BY m.movie_id, g.genre_name
LIMIT 20;

-- The following MUST return zero rows:
SELECT mg.* FROM schema_clean.movie_genres AS mg
LEFT JOIN schema_clean.movies AS m USING (movie_id)
LEFT JOIN schema_clean.genres AS g USING (genre_id)
WHERE m.movie_id IS NULL OR g.genre_id IS NULL
LIMIT 10;


SELECT COUNT(*) AS total_movies_raw
FROM schema_temporary.title_basics;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'schema_clean'
ORDER BY table_name;

SELECT *
FROM schema_clean.movies
LIMIT 10;

SELECT *
FROM schema_clean.genres
ORDER BY genre_name;


-- Check for duplicated movie IDs
SELECT movie_id, COUNT(*)
FROM schema_clean.movies
GROUP BY movie_id
HAVING COUNT(*) > 1;

-- Check for genres without names
SELECT *
FROM schema_clean.genres
WHERE genre_name IS NULL OR genre_name = '';

-- Check for movie-genre references with no matching movie
SELECT mg.*
FROM schema_clean.movie_genres mg
LEFT JOIN schema_clean.movies m
    ON mg.movie_id = m.movie_id
WHERE m.movie_id IS NULL;


SELECT
    m.title,
    m.release_year,
    g.genre_name
FROM schema_clean.movie_genres mg
JOIN schema_clean.movies m
    ON mg.movie_id = m.movie_id
JOIN schema_clean.genres g
    ON mg.genre_id = g.genre_id
LIMIT 20;

SELECT 'movies' AS table_name, COUNT(*) AS total_rows
FROM schema_clean.movies

UNION ALL

SELECT 'genres', COUNT(*)
FROM schema_clean.genres

UNION ALL

SELECT 'movie_genres', COUNT(*)
FROM schema_clean.movie_genres;


SELECT movie_id, genre_id, COUNT(*)
FROM schema_clean.movie_genres
GROUP BY movie_id, genre_id
HAVING COUNT(*) > 1;
-- no duplicates


SELECT movie_id, genre_id, COUNT(*)
FROM schema_clean.movie_genres
GROUP BY movie_id, genre_id
HAVING COUNT(*) > 1;

SELECT mg.*
FROM schema_clean.movie_genres mg
LEFT JOIN schema_clean.genres g
    ON mg.genre_id = g.genre_id
WHERE g.genre_id IS NULL;