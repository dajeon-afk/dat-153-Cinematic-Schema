BEGIN;

-- Rerunnable: clear in child-to-parent order. Fails safely if cast/crew rows already reference movies.
DELETE FROM movie_genres;
DELETE FROM movies;
DELETE FROM genres;

-- 1. movies: tt0000009 -> 9. The same rule must be used for every table that references a movie.
INSERT INTO movies (movie_id, title, release_date, runtime)
SELECT DISTINCT ON (tconst)
       CAST(SUBSTRING(tconst FROM 3) AS integer),
       title,
       CASE WHEN release_year ~ '^\d{4}$' THEN make_date(release_year::int, 1, 1) END,
       CASE WHEN runtime ~ '^\d+$' THEN runtime::integer END
FROM schema_clean.movies
ORDER BY tconst;

-- 2. genres: one row per distinct name, with stable IDs (alphabetical)
INSERT INTO genres (genre_id, genre_name)
SELECT row_number() OVER (ORDER BY g), g
FROM (
    SELECT DISTINCT trim(g) AS g
    FROM schema_clean.movies,
         regexp_split_to_table(genres, ',') AS g
    WHERE genres IS NOT NULL AND genres NOT IN ('', '\N') AND trim(g) <> ''
) AS d;

-- 3. movie_genres: the IDs come from joining on the name, so they match
INSERT INTO movie_genres (movie_id, genre_id)
SELECT DISTINCT
       CAST(SUBSTRING(m.tconst FROM 3) AS integer),
       ge.genre_id
FROM schema_clean.movies AS m,
     regexp_split_to_table(m.genres, ',') AS g
JOIN genres AS ge ON ge.genre_name = trim(g)
WHERE m.genres IS NOT NULL AND m.genres NOT IN ('', '\N');

COMMIT;