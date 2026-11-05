BEGIN;

DELETE FROM ratings;

-- IMDb rating 7.3 is stored as 73 (rating_value is an integer).
-- title_ratings has duplicate rows per movie, so keep one per movie first.
INSERT INTO ratings (rating_id, movie_id, rating_source, rating_value)
SELECT row_number() OVER (ORDER BY d.movie_id),
       d.movie_id,
       'IMDb',
       d.rating_value
FROM (
    SELECT DISTINCT ON (m.movie_id)
           m.movie_id,
           round(tr."averageRating"::numeric * 10)::integer AS rating_value
    FROM schema_temporary.title_ratings AS tr
    JOIN movies AS m
      ON tr.tconst ~ '^tt\d+$'
     AND m.movie_id = CAST(SUBSTRING(tr.tconst FROM 3) AS integer)
    WHERE tr."averageRating" ~ '^\d+(\.\d+)?$'
    ORDER BY m.movie_id
) AS d;

COMMIT;