CREATE SCHEMA IF NOT EXISTS schema_clean;

CREATE TABLE schema_clean.movies AS
SELECT
    tconst,
    "primaryTitle" AS title,
    "startYear" AS release_year,
    "runtimeMinutes" AS runtime,
    genres
FROM schema_temporary.title_basics
WHERE "titleType" = 'movie';

SELECT *
FROM movies
LIMIT 10;