-- Indexes

CREATE INDEX IF NOT EXISTS ix_movie_genres_movie_id
ON public.movie_genres (movie_id);

CREATE INDEX IF NOT EXISTS ix_movies_title
ON public.movies (title);

-- Speeds up searches for movies released within a date range
CREATE INDEX IF NOT EXISTS ix_movies_release_date
ON public.movies (release_date);


-- Speeds up searches for actors by their full name
CREATE INDEX IF NOT EXISTS ix_people_name
ON public.people (name);

CREATE INDEX IF NOT EXISTS ix_movies_release_date
ON public.movies (release_date);

EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title, release_date
FROM public.movies
WHERE release_date >= DATE '2015-01-01'
  AND release_date < DATE '2016-01-01';